using System;
using System.IO;
using System.IO.Compression;
using System.Xml;
using System.Xml.Xsl;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using SelectPdf;

namespace eInvoiceApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FatturaElettronicaController : ControllerBase
    {
        public static IConfiguration _appConfiguration;
        public FatturaElettronicaController(IConfiguration appConfiguration)
        {
            _appConfiguration = appConfiguration;
        }

        [HttpPost]
        public RequestResult Start(string xmlFilePath)
        {
            if (xmlFilePath.Contains("\"")) xmlFilePath = xmlFilePath.Replace("\"", ""); // Useful when user copy file path as a quoted string

            RequestResult requestResult = new();
            requestResult.SourceFilePath = xmlFilePath;

            string fileName = Path.GetFileName(xmlFilePath);
            string fileNameWithoutExtension = fileName.Substring(0, fileName.LastIndexOf("."));
            string fileExtension = xmlFilePath[(xmlFilePath.LastIndexOf(".") + 1)..].ToUpper();

            if (fileExtension == "XML")
            {
                string desktopPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
                var savingPath = $"{desktopPath}\\eInvoiceApi-generated";

                if (!Directory.Exists(savingPath))
                {
                    Directory.CreateDirectory(savingPath);
                }

                ConvertFile(xmlFilePath, fileNameWithoutExtension, savingPath);
                requestResult.Status = true;
                requestResult.Message = $"File converted in HTML & PDF! You can find these files in ({savingPath}\\{fileNameWithoutExtension})";


                XmlDocument XmlDoc = new();
                XmlDoc.Load(xmlFilePath);
                if (XmlDoc.SelectSingleNode("//Allegati") != null)
                {
                    string targetFolderforAttachment = Path.GetDirectoryName(xmlFilePath);
                    string xPath = string.Format(_appConfiguration["FatturaElettronicaITA:XMLAttachmentsPath"], _appConfiguration["FatturaElettronicaITA:attachmentsTagName"]);

                    XmlNodeList elements = XmlDoc.SelectNodes(xPath);
                    foreach (XmlElement element in elements)
                    {
                        string attachment = element.SelectSingleNode("Attachment").InnerText;
                        string attachmentName = element.SelectSingleNode("NomeAttachment").InnerText;
                        
                        if (attachment != "")
                        {
                            ManageAttachment(targetFolderforAttachment, attachmentName, attachment);
                        }
                        else
                        {
                            requestResult.Status = false;
                            requestResult.Message += $" Attachment content: ({attachmentName}) from: ({xmlFilePath}) is empty.";
                            return requestResult;
                        }
                    }

                    requestResult.Status = true;
                    requestResult.Message += $" Attachments extracted successfully!";
                }
                else
                {
                    requestResult.Status = false;
                    requestResult.Message += $" <Allegati> XML_Node from file: {xmlFilePath} does not exist. No attachments were found...";
                    return requestResult;
                }
            }
            else
            {
                requestResult.Status = false;
                requestResult.Message = $"Please upload a valid *.XML file.";
            }

            return requestResult;
        }

        public static void ConvertFile(string path, string name, string locationSavingPath)
        {
            string specificSavingDirectory = $"{locationSavingPath}\\{name}";
            if (!Directory.Exists(specificSavingDirectory))
            {
                Directory.CreateDirectory(specificSavingDirectory);
            }
            string htmlFilePath = $"{specificSavingDirectory}\\{name}.html";
            string pdfFilePath = $"{specificSavingDirectory}\\{name}.pdf";

            XslCompiledTransform XslCT = new();
            XslCT.Load(@"C:\coding\c#\eInvoiceApi\Utilities\ItalWorkStyleSheet.xsl");
            XslCT.Transform(path, htmlFilePath);


            HtmlToPdf HtmlToPdfconverter = new();
            GlobalProperties.HtmlEngineFullPath = Path.Combine(Directory.GetCurrentDirectory(), "Utilities/Select.Html.dep");
            HtmlToPdfconverter.Options.MaxPageLoadTime = 120; // Useful to avoid timing exception

            var document = HtmlToPdfconverter.ConvertUrl(htmlFilePath);
            document.Save(pdfFilePath);
            document.Close();
        }

        public static void ManageAttachment(string path, string attachmentName, string attachment)
        {
            attachmentName = attachmentName.Replace("/", "_");
            string AttachmentPath = string.Format(_appConfiguration["FatturaElettronicaITA:attachmentsFolder"], path);

            if (!Directory.Exists(AttachmentPath))
            {
                Directory.CreateDirectory(AttachmentPath);
            }

            var decodedFileBytes = Convert.FromBase64String(attachment);

            string TheExt = attachmentName[(attachmentName.LastIndexOf(".") + 1)..].ToUpper();
            if (TheExt == "ZIP")
            {
                System.IO.File.WriteAllBytes(path + @"\" + attachmentName, decodedFileBytes);

                if (Directory.Exists(path))
                {
                    Directory.Delete(path, true);
                }

                Decompress(path + @"\" + attachmentName, path);
            }
            else
            {
                System.IO.File.WriteAllBytes(AttachmentPath + attachmentName, decodedFileBytes);
            }
        }

        public static void Decompress(string directoryPath, string targetPath)
        {
            FileInfo fileToDecompress = new(directoryPath);

            using FileStream originalFileStream = fileToDecompress.OpenRead();
            string currentFileName = fileToDecompress.FullName;

            ZipFile.ExtractToDirectory(currentFileName, targetPath);
        }

        public class RequestResult
        {
            public bool Status { get; set; }
            public string Message { get; set; }
            public string SourceFilePath { get; set; }
        }
    }
}

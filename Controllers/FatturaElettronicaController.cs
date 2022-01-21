using System;
using System.IO;
using System.Xml.Xsl;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

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
            string fileExtension = xmlFilePath.Substring(xmlFilePath.LastIndexOf(".") + 1).ToUpper();

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
                requestResult.Message = $"File converted in HTML!";
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

            XslCompiledTransform XslCT = new();
            XslCT.Load(@"C:\coding\c#\eInvoiceApi\Utilities\ItalWorkStyleSheet.xsl");
            XslCT.Transform(path, htmlFilePath);
        }

        public class RequestResult
        {
            public bool Status { get; set; }
            public string Message { get; set; }
            public string SourceFilePath { get; set; }
        }
    }
}

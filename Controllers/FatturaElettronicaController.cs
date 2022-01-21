using System;
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
            requestResult.Status = true;
            requestResult.Message = $"Everything is ok!";
            requestResult.SourceFilePath = xmlFilePath;
            return requestResult;
        }

        public class RequestResult
        {
            public bool Status { get; set; }
            public string Message { get; set; }
            public string SourceFilePath { get; set; }
        }
    }
}

/*
    Carpenter.AzurePipelines
    Common YAML templates and scripts for Azure Pipelines definitions.

    Copyright © 2015-2019 Nosnitor Corporation, All rights reserved.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
*/
// SPDX-License-Identifier: MIT

using Shouldly;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;
using Xunit;
using Xunit.Sdk;

namespace Carpenter.AzurePipelines.PipelineYamlTests
{
    public class YamlFilesDataAttribute : DataAttribute
    {

        public override IEnumerable<object[]> GetData(MethodInfo testMethod)
        {
            var data = new List<object[]> { };
            var curDir = Directory.GetCurrentDirectory();
            var files = Directory.GetFiles(curDir, "*.yml", SearchOption.AllDirectories);
            var separator = Path.DirectorySeparatorChar;
            foreach (var file in files)
            {
                data.Add(new object[] { file.Replace($"{curDir}{separator}", "") });

            }
            return data;
        }
    }


    /// <summary>
    /// Validates the Copyright/License header in YAML template files.
    /// </summary>
    public class CopyrightLicenseHeader
    {
        public string expectedCopyrightLicense = @"#    Carpenter.AzurePipelines
#    Common YAML templates and scripts for Azure Pipelines definitions.
#
#    Copyright © 2015-2019 Nosnitor Corporation, All rights reserved.
#
#    Permission is hereby granted, free of charge, to any person obtaining a copy
#    of this software and associated documentation files (the ""Software""), to deal
#    in the Software without restriction, including without limitation the rights
#    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#    copies of the Software, and to permit persons to whom the Software is
#    furnished to do so, subject to the following conditions:
#
#    The above copyright notice and this permission notice shall be included in all
#    copies or substantial portions of the Software.
#
#    THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#    SOFTWARE.

# SPDX-License-Identifier: MIT

";

        /// <summary>
        /// Validates yml files contain copyright/license header.
        /// </summary>
        /// <remarks>
        /// This test will fail if no yml files are present in output.
        /// </remarks>
        /// <param name="fileName">The files to validate.</param>
        [Theory]
        [YamlFilesData]
        public void ShouldBeValid(string fileName)
        {
            var fileText = File.ReadAllText(fileName);
            fileText.ShouldStartWith(expectedCopyrightLicense);
        }
    }
}

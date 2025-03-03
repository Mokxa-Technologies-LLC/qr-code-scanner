<div class="form-cell qr_code_scanner" ${elementMetaData!}>
    <#if  (element.properties.hideLabel! == 'true')>
        <label field-tooltip="${elementParamName!}" class="label ui-screen-hidden" for="${elementParamName!}">${element.properties.label!} <span class="form-cell-validator">${decoration!}</span><#if error??> <span class="form-error-message">${error}</span></#if></label>
    <#else>
        <label field-tooltip="${elementParamName!}" class="label" for="${elementParamName!}">${element.properties.label!} <span class="form-cell-validator">${decoration!}</span><#if error??> <span class="form-error-message">${error}</span></#if></label>
    </#if>
    <div class="form-cell-value qr_code_scanner_child">
        <span>${valueLabel!?html}</span>
        <input class="qr_scanner" id="${elementParamName!}" name="${elementParamName!}" type="hidden" value="${value!?html}"/>
        <#if  (element.properties.hideOnLoad! == 'true')>
            <div id="reader" class="hidden"></div>
        <#else>
            <div id="reader"></div>
        </#if>
        <div id="qr-error-message" class="qr-error-message hidden">Camera Access : Permission Denied</div>
        <#if  (element.properties.hideOnLoad! == 'true')>
            <button id="rescan-button" name="rescan-button">Scan QR Code</button>
        <#else>
            <button id="rescan-button" name="rescan-button" class="hidden">Scan QR Code</button>
        </#if>
        <div id="qr-scanned-value" class="hidden">
            <br>
            <div class="qr-scanned-value"></div>
        </div>
    </div>

    <style>
        <#if  (element.properties.hideLabel! == 'true')>
            .qr_code_scanner_child {
                width: 100% !important;
            }
        </#if>

        .qr_code_scanner_child {
            width: 100%;
            display: flex;
            flex-direction: column;  /* Stack elements vertically */
            align-items: center;  /* Center elements horizontally */
            justify-content: center;  /* Center elements vertically */
        }

        #reader {
            width: 100%; /* Larger area for better scanning */
            max-width: 650px; 
            border: 2px solid #333;
            border-radius: 5px;
            margin-bottom: 20px;
            border-color: #808080;
        }

        <#if ("${element.properties.size!}" != '')>
            #reader {
                max-width: ${element.properties.size!}px !important;
            }
        </#if>

        #reader video {
            width: 100% !important;   /* Makes the video fill the parent container's width */
            height: auto !important;  /* Maintain aspect ratio */
            display: block !important; /* Keeps it block-level */
        }

        .hidden {
            display: none;   /* Class to hide elements */
        }

        #rescan-button {
            margin-bottom: 20px;
            padding: 5px 20px;
            width: 100%;
            font-size: 16px;
            cursor: pointer;
            border-radius:5px;
            border-color: #808080;

            align-self: flex-end;
        }
    </style>

    <script src="https://unpkg.com/html5-qrcode@2.3.8/html5-qrcode.min.js"></script>
    <script>

        var html5QrCode = undefined;
        function define() {
            var defineQRCode = false;
            var errorLogged = false;

            // Function to start the scanner
            function startScanner() {
                var hiddenInput;
                var showValue = false;
                var rescanButton = document.getElementById('rescan-button');
                var parentDivs = document.querySelectorAll(".qr_code_scanner");
                var errorMessageDiv = document.getElementById('qr-error-message');
                var qrScannedValue = document.getElementById('qr-scanned-value');
                var readerDiv = document.getElementById('reader');
                if ("${element.properties.showValue!}" == "true") {
                    showValue = true;
                }
                if (html5QrCode == undefined) {
                    html5QrCode = new Html5Qrcode("reader");
                }

                //console.log("Starting QR code scanner...");
                try {
                    html5QrCode.start(
                        { facingMode: "environment" }, // Use the front-facing camera (default for laptops)
                        {
                            fps: 10, // Frames per second
                            qrbox: 250 // Size of the QR code scanning box
                        },
                        (decodedText, decodedResult) => {
                            // Update the hidden input field
                            parentDivs.forEach(parentDiv => {
                                hiddenInput = parentDiv ? parentDiv.querySelector("#${elementParamName!}") : null;

                                if (hiddenInput) {
                                    hiddenInput.value = decodedText;
                                    if (showValue) {
                                        qrScannedValue.innerHTML = "Scanned QR Code value: " + decodedText + "<br>";
                                    }
                                }
                            });

                            // Trigger the change event
                            const event = new Event('change', { bubbles: true });
                            hiddenInput.dispatchEvent(event);
                            //console.log("Change event triggered.");

                            errorLogged = false; // Reset error flag

                            // Hide the reader div after successful scan
                            readerDiv.classList.add("hidden");

                            // Show the rescan button
                            rescanButton.classList.remove("hidden");

                            qrScannedValue.classList.remove("hidden");

                            html5QrCode.stop(); // Stop scanning after a successful scan
                        },
                        (errorMessage) => {
                            // Handle scanning errors
                            if (!errorLogged) {
                                //console.error("QR Code Scan Error:", errorMessage);
                                errorLogged = true; // Set error flag to prevent repetitive logging
                            }
                        }
                    ).catch((err) => {
                        // Handle initialization errors
                        readerDiv.classList.add("hidden");
                        errorMessageDiv.classList.remove("hidden");
                        //errorMessageDiv.innerHTML = "Error: " + err;
                        console.error("Unable to start the scanner:", err);
                    });
                } catch (err) {
                    //console.log(err);
                }
            }

            var hideScanner = false;
            if ("${element.properties.hideOnLoad!}" == "true") {
                hideScanner = true;
            }

            // Check if the browser supports the required APIs
            if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
                console.error("Your browser does not support camera access.");
            } else {
                if (!hideScanner) {
                    // Start the scanner when the page loads
                    startScanner();
                }
            }

            $(document).on('click', '#rescan-button', function() {
                //console.log('button clicked');

                const rescanButton = document.getElementById('rescan-button');
                const readerDiv = document.getElementById('reader');
                const qrScannedValue = document.getElementById('qr-scanned-value');

                event.preventDefault();
                event.stopPropagation();

                // Hide the rescan button
                rescanButton.classList.add("hidden");

                // Show the reader div
                readerDiv.classList.remove("hidden");

                // Hide scanned value
                qrScannedValue.classList.add("hidden");

                startScanner();
            });

            defineQRCode = true;
        }

        $( document ).ready(function() {
            setTimeout(function() {
                define();
            }, 500); 
        });

    </script>
</div>
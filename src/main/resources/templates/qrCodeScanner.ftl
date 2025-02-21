<div class="form-cell qr_code_scanner" ${elementMetaData!}>
    <label field-tooltip="${elementParamName!}" class="label" for="${elementParamName!}">${element.properties.label!} <span class="form-cell-validator">${decoration!}</span><#if error??> <span class="form-error-message">${error}</span></#if></label>
    <div class="form-cell-value qr_code_scanner_child">
        <span>${valueLabel!?html}</span>
        <input class="qr_scanner" id="${elementParamName!}" name="${elementParamName!}" type="hidden" value="${value!?html}"/>
        <div id="reader"></div>
        <div id="qr-error-message" class="qr-error-message hidden">Camera Access : Permission Denied</div>
        <button id="rescan-button" name="rescan-button" class="hidden">Rescan QR Code</button>
    </div>

<style>
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

    <script src="https://unpkg.com/html5-qrcode"></script>
    <script>
        // Debugging: Log when the script is loaded
        $( document ).ready(function() {
            //console.log("QR Code Scanner script loaded.");

            const html5QrCode = new Html5Qrcode("reader");
            const readerDiv = document.getElementById('reader');
            const rescanButton = document.getElementById('rescan-button');
            var hiddenInput;
            const parentDivs = document.querySelectorAll(".qr_code_scanner");
            const errorMessageDiv = document.getElementById('qr-error-message');

            // Variable to track if an error has already been logged
            let errorLogged = false;

            

            // Function to start the scanner
            function startScanner() {
                //console.log("Starting QR code scanner...");
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
            }

            // Function to restart the scanner
            function restartScanner(event) {
                event.preventDefault();
                event.stopPropagation();

                //console.log("Restarting QR code scanner...");

                // Hide the rescan button
                rescanButton.classList.add("hidden");

                // Show the reader div
                readerDiv.classList.remove("hidden");

                // Restart the scanner
                startScanner();
            }

            // Add click event listener to the rescan button
            rescanButton.addEventListener("click", restartScanner);

            // Check if the browser supports the required APIs
            if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
                console.error("Your browser does not support camera access.");
            } else {
                // Start the scanner when the page loads
                startScanner();
            }
        });
    </script>
</div>
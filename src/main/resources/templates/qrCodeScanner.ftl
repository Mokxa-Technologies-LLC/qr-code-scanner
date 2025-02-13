<div class="form-cell qr_code_scanner" ${elementMetaData!}>
    <label field-tooltip="${elementParamName!}" class="label" for="${elementParamName!}">${element.properties.label} <span class="form-cell-validator">${decoration}</span><#if error??> <span class="form-error-message">${error}</span></#if></label>
    <div class="form-cell-value"><span>${valueLabel!?html}</span>
		<input id="${elementParamName!}" name="${elementParamName!}" type="hidden" value="${value!?html}"/>
		<div id="scannerCam" style="display: inline;"></div>
	</div>
    <style>
        div#scannerCam video.qrPreviewVideo {
            width: 100%;
            max-width: 600px;
        }
    </style>
    <script type="text/javascript" src="${request.contextPath}/plugin/org.mokxa.qrscanner.QRCodeScanner/js/jsqrscanner.nocache.js"></script>
    <script type="text/javascript">
        function onQRCodeScanned(scannedText)
        {
            $(FormUtil.getField("${elementParamName!}")).val(scannedText).trigger("change");
        }
    
        function JsQRScannerReady()
        {
			console.log("RANNNNN");
            var jbScanner = new JsQRScanner(onQRCodeScanned);
			console.log("test: jbScanner -" + jbScanner);
            jbScanner.setSnapImageMaxSize(600);
            var scannerParentElement = document.getElementById("scannerCam");
            if(scannerParentElement)
            {
                jbScanner.appendTo(scannerParentElement);
            }
        }
    </script>
</div>
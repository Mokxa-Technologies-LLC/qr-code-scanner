<div class="form-cell qr_code_scanner" ${elementMetaData!}>
	<label field-tooltip="${elementParamName!}" class="label" for="${elementParamName!}">${element.properties.label} <span class="form-cell-validator">${decoration}</span><#if error??> <span class="form-error-message">${error}</span></#if></label>
	<div class="form-cell-value"><span>${valueLabel!?html}</span></div>
	<input id="${elementParamName!}" name="${elementParamName!}" type="hidden" value="${value!?html}"/>
	<div id="qrCodeScanner" style="display: inline;"></div>
	<style>
		div#qrCodeScanner video.qrPreviewVideo {
			width: 100%;
			max-width: 600px;
		}
	</style>
	<script type="text/javascript" src="${request.contextPath}/org.mokxa.qrscanner/js/jsqrscanner.nocache.js"></script>
	<script type="text/javascript">
		function onQRCodeScanned(scannedText)
		{
			$(FormUtil.getField(${elementParamName!})).val(scannedText).trigger("change");
		}
	
		function JsQRScannerReady()
		{
			var jbScanner = new JsQRScanner(onQRCodeScanned);
			jbScanner.setSnapImageMaxSize(600);
			var scannerParentElement = document.getElementById("qrCodeScanner");
			if(scannerParentElement)
			{
				jbScanner.appendTo(scannerParentElement);
			}
		}
	</script>
</div>
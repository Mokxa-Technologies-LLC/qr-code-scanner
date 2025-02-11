package org.mokxa.qrscanner;

import java.util.Map;
import org.joget.apps.app.service.AppPluginUtil;
import org.joget.apps.app.service.AppUtil;
import org.joget.apps.form.lib.Radio;
import org.joget.apps.form.lib.HiddenField;
import org.joget.apps.form.model.FormBuilderPalette;
import org.joget.apps.form.model.FormData;
import org.joget.apps.form.service.FormUtil;

public class QRCodeScanner extends HiddenField {
    
    private final static String MESSAGE_PATH = "message/form/MoodRatingField";
    
    @Override
    public String getName() {
        return "QR Code Scanner";
    }

    @Override
    public String getVersion() {
        return "1.0.0";
    }
    
    @Override
    public String getClassName() {
        return getClass().getName();
    }
    
    @Override
    public String getFormBuilderCategory() {
        return FormBuilderPalette.CATEGORY_CUSTOM;
    }
    
    @Override
    public String getLabel() {
        //support i18n
        return AppPluginUtil.getMessage("qrscanner.QRScanner.pluginLabel", getClassName(), MESSAGE_PATH);
    }

    @Override
    public String getDescription() {
        //support i18n
        return AppPluginUtil.getMessage("qrscanner.QRScanner.pluginDesc", getClassName(), MESSAGE_PATH);
    }
    
    @Override
    public String getPropertyOptions() {
        return AppUtil.readPluginResource(getClass().getName(), "/properties/form/qrScanner.json", null, true, MESSAGE_PATH);
    }
    
    @Override
    public String renderTemplate(FormData formData, Map dataModel) {
        String template = "qrScanner.ftl";
        
        // set value
        String value = FormUtil.getElementPropertyValue(this, formData);
        dataModel.put("value", value);

        String html = FormUtil.generateElementHtml(this, formData, template, dataModel);
        return html;
    }
    
    @Override
    public String getFormBuilderTemplate() {
        return "<label class='label'>"+getLabel()+"</label>";
    }
}

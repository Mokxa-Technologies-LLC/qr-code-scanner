package org.mokxa.qrscanner;

import org.joget.apps.app.service.AppPluginUtil;
import org.joget.apps.app.service.AppUtil;
import org.joget.apps.form.lib.Radio;
import org.joget.apps.form.lib.TextField;
import org.joget.apps.form.model.FormBuilderPalette;
import org.joget.apps.form.model.FormRow;
import org.joget.apps.form.model.FormData;
import org.joget.apps.form.service.FormUtil;
import org.joget.apps.form.model.Element;
import org.joget.apps.form.model.FormBuilderPaletteElement;

import java.util.Map;
import java.util.Collections;
import java.util.Collection;
import java.util.ArrayList;
import java.util.List;
import org.joget.commons.util.LogUtil;
import org.joget.commons.util.SecurityUtil;

public class QRCodeScanner extends Element implements FormBuilderPaletteElement {

    private final static String MESSAGE_PATH = "message/form/QRCodeScanner";
    
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
    public String getFormBuilderIcon() {
        return "<i class=\"fas fa-qrcode\"></i>";
    }

    @Override
    public int getFormBuilderPosition() {
        return 500;
    }

    @Override
    public String getLabel() {
        // support i18n
        return AppPluginUtil.getMessage("org.mokxa.QRCodeScanner.pluginLabel", getClassName(), MESSAGE_PATH);
        //return "QR Code Scanner";
    }

    @Override
    public String getDescription() {
        // support i18n
        return AppPluginUtil.getMessage("org.mokxa.QRCodeScanner.pluginDesc", getClassName(), MESSAGE_PATH);
        //return "Form Field for scanning QR codes";
    }

    @Override
    public String getPropertyOptions() {
        return AppUtil.readPluginResource(getClass().getName(), "/properties/form/qrCodeScanner.json", null, true, MESSAGE_PATH);
    }

    @Override
    public String renderTemplate(FormData formData, Map dataModel) {
        String template = "qrCodeScanner.ftl";

        // set value
        String value = FormUtil.getElementPropertyValue(this, formData);
        dataModel.put("value", value);
        
        String html = FormUtil.generateElementHtml(this, formData, template, dataModel);
        return html;
    }

    @Override
    public String getFormBuilderTemplate() {
        return "<label class='label'>" + getLabel() + "</label>";
    }
}

<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Import.aspx.cs" Inherits="Member_Import" Title="Import Logbook" culture="auto" meta:resourcekey="PageResource1"  %>
<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Register src="../Controls/mfbImportAircraft.ascx" tagname="mfbImportAircraft" tagprefix="uc1" %>
<%@ Register Src="~/Controls/Expando.ascx" TagPrefix="uc1" TagName="Expando" %>
<%@ Register Src="~/Controls/mfbTooltip.ascx" TagPrefix="uc1" TagName="mfbTooltip" %>

<asp:Content ID="ContentHead" ContentPlaceHolderID="cpPageTitle" runat="server">
    <asp:Localize ID="locHeader" runat="server" Text="Importing Data" meta:resourcekey="locHeaderResource1" 
            ></asp:Localize>
</asp:Content>
<asp:Content ID="ContentTopForm" ContentPlaceHolderID="cpTopForm" runat="server">
    <asp:Wizard ID="wzImportFlights" runat="server" onfinishbuttonclick="Import"
        DisplaySideBar="False"
        onactivestepchanged="wzImportFlights_ActiveStepChanged"          
        FinishCompleteButtonText="Import" meta:resourcekey="wzImportFlightsResource1">
        <HeaderTemplate>
            <div style="width:100%">
                <asp:Repeater ID="SideBarList" runat="server">
                    <ItemTemplate>
                        <span class="<%# GetClassForWizardStep(Container.DataItem) %>">
                            &nbsp;
                            <%# DataBinder.Eval(Container, "DataItem.Title") %>
                        </span>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </HeaderTemplate>
        <WizardSteps>
            <asp:WizardStep ID="wsCreateFile" runat="server" 
                Title="1. Prepare your data for import" meta:resourcekey="wsCreateFileResource1" >
                <p>
                    <asp:Label ID="lblNewDirectImport" runat="server" Text="<%$ Resources:LocalizedText, HeaderDownloadIsNew %>" Font-Bold="true" meta:resourcekey="lblNewDirectImportResource1"></asp:Label>
                    <asp:Label ID="lblDirectImport" runat="server" Text="If your data is from FOREFLIGHT, ZULULOG, LOGTEN PRO, or ELOGSITE�you should be able to simply export your data in <a href='http://en.wikipedia.org/wiki/Comma-separated_values' target='_blank\'>CSV</a> format from that program and import it directly here." meta:resourcekey="lblDirectImportResource1"></asp:Label>
                </p>
                <p>
                    <asp:Localize ID="locStep1DescSpreadsheet" runat="server" Text="Otherwise, you must first create a table of your flights in a spreadsheet such as Excel and save it in <a href='http://en.wikipedia.org/wiki/Comma-separated_values' target='_blank\'>CSV</a> (spreadsheet) format.  The first row of the table must be headers that identify which column is which, with one flight per row on the rows that follow." meta:resourcekey="locStep1DescSpreadsheetResource1"></asp:Localize>
                </p>
                <ul>
                    <li><asp:HyperLink ID="lnkImportTable" runat="server" Font-Bold="True" 
                            NavigateUrl="~/Public/ImportTable.aspx" Target="_blank" 
                            Text="Description of spreadsheet columns" meta:resourcekey="lnkImportTableResource1" 
                            ></asp:HyperLink></li>
                    <li><asp:LinkButton ID="lnkDefaultTemplate" runat="server" Font-Bold="True" 
                            OnClick="lnkDefaultTemplate_Click"
                            Text="Download a starting CSV File template" meta:resourcekey="lnkDefaultTemplateResource1" 
                            ></asp:LinkButton></li>
                </ul>
                <p><asp:Label ID="lblTipsHeader" Font-Bold="true" runat="server" Text="" meta:resourcekey="lblTipsHeaderResource1"></asp:Label></p>
                <div><asp:Literal ID="litTipsFAQ" runat="server" meta:resourcekey="litTipsFAQResource1"></asp:Literal></div>
            </asp:WizardStep>
            <asp:WizardStep ID="wsUpload" runat="server" Title="2. Upload your file" meta:resourcekey="wsUploadResource1" 
                >
                <p>
                    <asp:Localize ID="locStep3Desc1" runat="server" Text="Upload your file and you can see a preview of what the import will look like 
                    without actually importing any data. This is a great way to troubleshoot. 
                    Your data will be scanned and any issues will be shown to you. You can 
                    then fix the issues prior to actually importing the data." meta:resourcekey="locStep3Desc1Resource1" 
                        ></asp:Localize>
                </p>
                <p>
                    <asp:Localize ID="locPreviewPrompt" runat="server" 
                        Text="Select a file to preview:" meta:resourcekey="locPreviewPromptResource1" ></asp:Localize>
                    <br />
                    <asp:FileUpload ID="fuPreview" runat="server" meta:resourcekey="fuPreviewResource1" 
                         />
                </p>
                <div style="white-space:pre"><asp:Label ID="lblFileRequired" runat="server" Text="" CssClass="error" EnableViewState="false" meta:resourcekey="lblFileRequiredResource1"></asp:Label></div>
            </asp:WizardStep>
            <asp:WizardStep ID="wsMissingAircraft" runat="server" Title="3. Review missing aircraft" meta:resourcekey="wsMissingAircraftResource1"  >
                <asp:MultiView ID="mvMissingAircraft" runat="server" ActiveViewIndex="0">
                    <asp:View ID="vwNoMissingAircraft" runat="server">
                        <p><asp:Label ID="lblNoMissingaircraft" runat="server" Text="All flight aircraft were found in your account!  You can proceed to preview." meta:resourcekey="lblNoMissingaircraftResource1" ></asp:Label></p>
                    </asp:View>
                    <asp:View ID="vwAddMissingAircraft" runat="server">
                        <p><asp:Label ID="lblMissingAircraft" runat="server" Text="The following aircraft are referenced by some of your flights, but are not yet in your profile:" meta:resourcekey="lblMissingAircraftResource1" ></asp:Label></p>
                        <uc1:mfbImportAircraft ID="mfbImportAircraft1" runat="server" />
                    </asp:View>
                </asp:MultiView>
                <br />
                <asp:Panel ID="pnlAudit" runat="server" Visible="false" Font-Size="Smaller" meta:resourcekey="pnlAuditResource1">
                    <uc1:Expando runat="server" ID="ExpandoAudit">
                        <Header>
                            <% =Resources.LogbookEntry.importAuditHeader %>
                        </Header>
                        <Body>
                            <asp:Panel ID="pnlConverted" runat="server">
                                <p><asp:Label ID="lblFileWasConverted" runat="server" Text=""></asp:Label> <asp:LinkButton ID="btnDownloadConverted" runat="server" Text="<%$ Resources:LogbookEntry, importLabelDownloadConverted %>" OnClick="btnDownloadConverted_Click" /></p>
                            </asp:Panel>
                            <br />
                            <div style="white-space:pre"><asp:Label ID="lblAudit" runat="server"></asp:Label></div>
                        </Body>
                    </uc1:Expando>
                    <asp:HiddenField ID="hdnAuditState" runat="server" />
                </asp:Panel>
            </asp:WizardStep>
            <asp:WizardStep ID="wsPreview" runat="server" Title="4. Preview" meta:resourcekey="wsPreviewResource1" 
                >
                <asp:Localize ID="locPreviewReady" runat="server" 
                    Text="When you are ready, you can import your data." meta:resourcekey="locPreviewReadyResource1" 
                    ></asp:Localize>
                <asp:Label ID="lblPreviewDontWorry" runat="server" Font-Bold="True" 
                    Text="Nothing will be imported if any problems are found." meta:resourcekey="lblPreviewDontWorryResource1" 
                    ></asp:Label>
                <br /><br />
                <asp:Label ID="lblImportant2" Font-Bold="true" runat="server" 
                    Text="Important: " meta:resourcekey="lblImportant2Resource1" ></asp:Label>
                <asp:Label ID="lblOnlyClickOnce" runat="server" 
                    Text="Only click to import once; otherwise, you can end up with duplicate entries." meta:resourcekey="lblOnlyClickOnceResource1" 
                    ></asp:Label>
                <asp:Label ID="lblUpdateOverwriteKey" runat="server" Text="Use the icons below to determine whether a flight is going to be updated, or if a new flight is going to be created." meta:resourcekey="lblUpdateOverwriteKeyResource1" ></asp:Label>
                <table>
                    <tr valign="middle">
                        <td><asp:Image ID="imgAddKey" runat="server" ImageAlign="Middle" ImageUrl="~/images/add.png" meta:resourcekey="imgAddKeyResource1"  /></td>
                        <td><asp:Label ID="lblKeyAdd" runat="server" Text="Flight will be ADDED - be sure it's not already present, or it will be a duplicate!" meta:resourcekey="lblKeyAddResource1" ></asp:Label></td>
                    </tr>
                    <tr valign="middle">
                        <td><asp:Image ID="imgUpdateKey" runat="server" ImageAlign="Middle" ImageUrl="~/images/update.png" meta:resourcekey="imgUpdateKeyResource1"  /></td>
                        <td><asp:Label ID="lblKeyUpdate" runat="server" Text="Flight to import matches an existing flight in your logbook and the existing flight will be updated." meta:resourcekey="lblKeyUpdateResource1" ></asp:Label></td>
                    </tr>
                </table>
                <asp:Label ID="lblError" runat="server" CssClass="error" EnableViewState="False" meta:resourcekey="lblErrorResource1"  ></asp:Label>
                <asp:PlaceHolder ID="plcErrorList" runat="server" EnableViewState="false"></asp:PlaceHolder>
            </asp:WizardStep>
        </WizardSteps>
        <StepNavigationTemplate>
            <asp:Button CommandName="MovePrevious" Runat="server" Text="Previous" />
            <asp:Button CommandName="MoveNext" Runat="server" Text="Next" />
        </StepNavigationTemplate>
        <FinishNavigationTemplate>
            <asp:Button ID="btnNewFile" OnClick="btnNewFile_Click" Runat="server" Visible="false" Text="Upload a new file " />
            <asp:Button CommandName="MovePrevious" Runat="server" Text="Previous" />
            <asp:Button CommandName="MoveComplete" Runat="server" Text="Import" />
        </FinishNavigationTemplate>
    </asp:Wizard>
    <asp:Panel ID="pnlImportSuccessful" runat="server" Visible="False" meta:resourcekey="pnlImportSuccessfulResource1" >
        <p><asp:Label ID="lblImportSuccessful" runat="server" Text="Import complete - results are shown below" meta:resourcekey="lblImportSuccessfulResource1" ></asp:Label></p>
        <p><asp:HyperLink ID="btnDone" runat="server" Text="View my flights" NavigateUrl="~/Member/LogbookNew.aspx" meta:resourcekey="btnDoneResource1"  /></p>
    </asp:Panel>
    <br /><br />
</asp:Content>
<asp:content id="Content1" contentplaceholderid="cpMain" runat="Server">
    <asp:MultiView ID="mvContent" runat="server">
        <asp:View ID="View1" runat="server"></asp:View>
        <asp:View ID="View2" runat="server"></asp:View>
        <asp:View ID="View3" runat="server"></asp:View>
        <asp:View ID="View4" runat="server">
    <div style="margin-left:auto; margin-right:auto; max-width:90%">
        <asp:MultiView ID="mvPreviewResults" runat="server">
            <asp:View runat="server" ID="vwPreviewResults">
                <asp:MultiView ID="mvPreview" runat="server">
                    <asp:View ID="vwPreview" runat="server">
                        <table style="width:100%; font-size: 8pt; border-color: gray; border-collapse:collapse" border="1" cellpadding="2">
                            <thead>
                                <tr style="font-weight:bold">
                                    <td></td>
                                    <td style="text-align:center"><%=Resources.LogbookEntry.FieldTail %></td>
                                    <td style="text-align:center"><%=Resources.LogbookEntry.FieldApproaches %></td>
                                    <td style="text-align:center"><%=Resources.LogbookEntry.FieldHold %></td>
                                    <td style="text-align:center">
                                        <% =Resources.LogbookEntry.FieldLanding %>
                                        <uc1:mfbTooltip runat="server" ID="mfbTooltip" BodyContent="<%$ Resources:LogbookEntry, LogbookLandingKey %>" />
                                    </td>
                                    <td style="text-align:center"><% =Resources.LogbookEntry.FieldXCountry %></td>
                                    <td style="text-align:center"><%=Resources.LogbookEntry.FieldNight %></td>
                                    <td style="text-align:center"><%=Resources.LogbookEntry.FieldSimIMC %></td>
                                    <td style="text-align:center"><%=Resources.LogbookEntry.FieldIMC %></td>
                                    <td style="text-align:center"><%=Resources.LogbookEntry.FieldGroundSim %></td>
                                    <td style="text-align:center"><%=Resources.LogbookEntry.FieldDual %></td>
                                    <td style="text-align:center"><%=Resources.LogbookEntry.FieldCFI %></td>
                                    <td style="text-align:center"><%=Resources.LogbookEntry.FieldSIC %></td>
                                    <td style="text-align:center"><%=Resources.LogbookEntry.FieldPIC %></td>
                                    <td style="text-align:center"><%=Resources.LogbookEntry.FieldTotal %></td>
                                </tr>
                            </thead>
                            <asp:Repeater ID="rptPreview" OnItemDataBound="rptPreview_ItemDataBound" runat="server">
                                <ItemTemplate>
                                    <tr runat="server" id="rowError" visible='<%# !String.IsNullOrEmpty((string) Eval("ErrorString")) %>' valign="top">
                                        <td colspan="15" runat="server">
                                            <div><asp:Label ID="lblFlightErr" CssClass="error" runat="server" Text='<%# Eval("ErrorString") %>'></asp:Label></div>
                                            <div><asp:Label ID="lblRawRow" CssClass="error" runat="server"></asp:Label></div>
                                        </td>
                                    </tr>
                                    <tr runat="server" id="rowFlight" style="vertical-align:top; text-align:center; border: 1px solid gray" class='<%# String.IsNullOrEmpty((string) Eval("ErrorString")) ? string.Empty : "error" %>'>
                                        <td style="text-align:left" runat="server">
                                            <div>
                                                <asp:Image ID="imgNewOrUpdate" runat="server" ImageUrl='<%# String.IsNullOrEmpty((string) Eval("ErrorString")) ? (Convert.ToBoolean(Eval("IsNewFlight")) ? "~/images/add.png" : "~/images/update.png") : "~/images/circleslash.png" %>' 
                                                ToolTip='<%# String.IsNullOrEmpty((string) Eval("ErrorString")) ? (Convert.ToBoolean(Eval("IsNewFlight")) ? Resources.LogbookEntry.ImportAddTooltip : Resources.LogbookEntry.ImportUpdateTooltip) : (string) Eval("ErrorString") %>' meta:resourcekey="imgNewOrUpdateResource1"  />
                                                <span style="font-weight:bold"><%# ((DateTime) Eval("Date")).ToShortDateString() %></span>
                                                <%# Eval("Route") %>
                                            </div>
                                            <div><%# Eval("Comment") %></div>
                                            <div><asp:PlaceHolder ID="plcAdditional" runat="server"></asp:PlaceHolder></div>
                                        </td>
                                        <td runat="server">
                                            <div style="font-weight:bold"><%# Eval("TailNumDisplay") %></div>
                                            <div><%# Eval("ModelDisplay") %></div>
                                            <div><%# Eval("CatClassDisplay") %></div>
                                        </td>
                                        <td runat="server"><%# Eval("Approaches").FormatInt() %></td>
                                        <td style="font-weight:bold" runat="server"><%# Eval("fHoldingProcedures").FormatBoolean() %></td>
                                        <td runat="server"><%# LogbookEntryDisplay.LandingDisplayForFlight((LogbookEntry) Container.DataItem) %></td>
                                        <td runat="server"><%# Eval("CrossCountry").FormatDecimal(UseHHMM) %></td>
                                        <td runat="server"><%# Eval("Nighttime").FormatDecimal(UseHHMM) %></td>
                                        <td runat="server"><%# Eval("SimulatedIFR").FormatDecimal(UseHHMM) %></td>
                                        <td runat="server"><%# Eval("IMC").FormatDecimal(UseHHMM) %></td>
                                        <td runat="server"><%# Eval("GroundSim").FormatDecimal(UseHHMM) %></td>
                                        <td runat="server"><%# Eval("Dual").FormatDecimal(UseHHMM) %></td>
                                        <td runat="server"><%# Eval("CFI").FormatDecimal(UseHHMM) %></td>
                                        <td runat="server"><%# Eval("SIC").FormatDecimal(UseHHMM) %></td>
                                        <td runat="server"><%# Eval("PIC").FormatDecimal(UseHHMM) %></td>
                                        <td runat="server"><%# Eval("TotalFlightTime").FormatDecimal(UseHHMM) %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </table>
                    </asp:View>
                    <asp:View ID="vwNoResults" runat="server">
                        <div style="text-align:center"><asp:Label ID="lblNoFlightsFound" runat="server" CssClass="error" Text="No flights were found to import!" meta:resourcekey="lblNoFlightsFoundResource1" ></asp:Label></div>
                    </asp:View>
                </asp:MultiView>
            </asp:View>
            <asp:View runat="server" ID="vwImportResults">
                <asp:PlaceHolder ID="plcProgress" runat="server"></asp:PlaceHolder>
            </asp:View>
        </asp:MultiView>
    </div>
        </asp:View>
    </asp:MultiView>
</asp:content>

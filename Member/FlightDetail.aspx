﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="FlightDetail.aspx.cs" Inherits="Member_FlightDetail" culture="auto" meta:resourcekey="PageResource1" %>
<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Reference Control="~/Controls/mfbLogbookSidebar.ascx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../Controls/mfbGoogleMapManager.ascx" TagName="mfbGoogleMapManager"
    TagPrefix="uc1" %>
<%@ Register Src="../Controls/GoogleChart.ascx" TagName="GoogleChart" TagPrefix="uc2" %>
<%@ Register Src="../Controls/mfbAccordionProxyControl.ascx" TagName="mfbAccordionProxyControl" TagPrefix="uc3" %>
<%@ Register Src="../Controls/mfbAccordionProxyExtender.ascx" TagName="mfbAccordionProxyExtender" TagPrefix="uc4" %>
<%@ Register Src="~/Controls/mfbAirportServices.ascx" TagPrefix="uc5" TagName="mfbAirportServices" %>
<%@ Register Src="~/Controls/mfbTooltip.ascx" TagPrefix="uc1" TagName="mfbTooltip" %>
<%@ Register Src="~/Controls/mfbImageList.ascx" TagPrefix="uc1" TagName="mfbImageList" %>
<%@ Register Src="~/Controls/mfbHoverImageList.ascx" TagPrefix="uc1" TagName="mfbHoverImageList" %>
<%@ Register Src="~/Controls/mfbSignature.ascx" TagPrefix="uc1" TagName="mfbSignature" %>
<%@ Register Src="~/Controls/mfbQueryDescriptor.ascx" TagPrefix="uc1" TagName="mfbQueryDescriptor" %>
<%@ Register Src="~/Controls/METAR.ascx" TagPrefix="uc1" TagName="METAR" %>
<%@ Register Src="~/Controls/mfbEditableImage.ascx" TagPrefix="uc1" TagName="mfbEditableImage" %>
<%@ Register Src="~/Controls/mfbVideoEntry.ascx" TagPrefix="uc1" TagName="mfbVideoEntry" %>


<asp:Content ID="ContentHead" ContentPlaceHolderID="cpPageTitle" runat="server">
    <asp:Localize ID="locPageHeader" runat="server" Text="<%$ Resources:LogbookEntry, FlightDetailsHeader %>"></asp:Localize>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="cpTopForm" runat="Server">
    <div>
        <asp:MultiView ID="mvReturn" runat="server" ActiveViewIndex="0">
            <asp:View ID="vwReturnOwner" runat="server">
                <asp:HyperLink ID="lnkListView" runat="server" Text="Return to list view" NavigateUrl="~/Member/LogbookNew.aspx" meta:resourcekey="lnkListViewResource1"></asp:HyperLink>
            </asp:View>
            <asp:View ID="vwReturnStudent" runat="server">
                <asp:HyperLink ID="lnkReturnStudent" runat="server"></asp:HyperLink>
            </asp:View>
        </asp:MultiView>
    </div>
    <p>
        <asp:Localize ID="locOverview" runat="server"
            Text="<%$ Resources:LogbookEntry, FlightDetailsDesc %>"></asp:Localize>
        <asp:HyperLink ID="lnkKey" NavigateUrl="~/Public/FlightDataKey.aspx"
            runat="server" Target="_blank" Text="<%$ Resources:LogbookEntry, FlightDetailsLearnAboutTelemetry %>" meta:resourcekey="lnkKeyResource1"></asp:HyperLink>
    </p>
    <asp:Panel runat="server" ID="pnlFlightDesc" Style="padding: 5px; margin-left: auto; margin-right: auto; margin-top: 5px; margin-bottom: 15px; text-align: center; background-color: #eeeeee; border: 1px solid darkgray; border-radius: 6px; box-shadow: 6px 6px 5px #888888;" meta:resourcekey="pnlFlightDescResource1">
        <asp:HiddenField ID="hdnNextID" runat="server" />
        <asp:HiddenField ID="hdnPrevID" runat="server" />
        <table style="width:100%">
            <tr style="vertical-align:middle">
                <td><asp:LinkButton ID="lnkPreviousFlight" runat="server" Font-Names="Arial" Text="<%$ Resources:LogbookEntry, PreviousFlight %>" Font-Size="Larger" OnClick="lnkPreviousFlight_Click" meta:resourcekey="lnkPreviousFlightResource1"></asp:LinkButton></td>
                <td>            
                    <p>
                        <asp:Label ID="lblFlightDate" Font-Bold="True" runat="server" meta:resourcekey="lblFlightDateResource1"></asp:Label>
                        <asp:Label ID="lblFlightDesc" style="white-space:pre-line" runat="server" meta:resourcekey="lblFlightDescResource1"></asp:Label>
                    </p>
                    <asp:Panel ID="pnlFilter" runat="server" Visible="false" >
                        <div style="display:inline-block;"><%=Resources.LocalizedText.ResultsFiltered %></div>
                            <uc1:mfbQueryDescriptor ID="mfbQueryDescriptor1" runat="server" OnQueryUpdated="mfbQueryDescriptor1_QueryUpdated" />
                    </asp:Panel>
                </td>
                <td><asp:LinkButton ID="lnkNextFlight" runat="server" Font-Names="Arial" Text="<%$ Resources:LogbookEntry, NextFlight %>" Font-Size="Larger" OnClick="lnkNextFlight_Click" meta:resourcekey="lnkNextFlightResource1"></asp:LinkButton></td>
            </tr>
        </table>
        <div>
        </div>
    </asp:Panel>
    <div>
        <asp:Label ID="lblPageErr" runat="server" CssClass="error" EnableViewState="False" meta:resourcekey="lblPageErrResource1"></asp:Label></div>
    <uc3:mfbAccordionProxyControl ID="mfbAccordionProxyControl1" runat="server" />
    <script type="text/javascript">
        function dropPin(p, s) {
            var gm = getMfbMap();
            gm.oms.addMarker(gm.addEventMarker(p, s));
        }

        function showUnitConvert(sender) {
            var r1 = document.getElementById("rowUnitConvert1");
            var r2 = document.getElementById("rowUnitConvert2");
            r1.style.visibility = r2.style.visibility = (sender.value == "Original") ? "hidden" : "visible";
        }
    </script>
    <uc4:mfbAccordionProxyExtender runat="server" ID="mfbAccordionProxyExtender" AccordionControlID="AccordionCtrl" HeaderProxyIDs="apcFlight,apcAircraft,apcChart,apcRaw,apcDownload" />
    <asp:Panel ID="pnlAccordionMenuContainer" CssClass="accordionMenuContainer" runat="server" meta:resourcekey="pnlAccordionMenuContainerResource1">
        <uc3:mfbAccordionProxyControl runat="server" LabelText="<%$ Resources:Tabs, AnalysisFlight %>" ID="apcFlight" />
        <uc3:mfbAccordionProxyControl runat="server" LabelText="<%$ Resources:Tabs, AnalysisAircraft %>" ID="apcAircraft" />
        <uc3:mfbAccordionProxyControl runat="server" LabelText="<%$ Resources:Tabs, AnalysisChart %>" ID="apcChart" />
        <uc3:mfbAccordionProxyControl runat="server" LabelText="<%$ Resources:Tabs, AnalysisRaw %>" ID="apcRaw" LazyLoad="true" OnControlClicked="apcRaw_ControlClicked" />
        <uc3:mfbAccordionProxyControl runat="server" LabelText="<%$ Resources:Tabs, AnalysisDownload %>" ID="apcDownload" />
    </asp:Panel>
    <ajaxToolkit:Accordion ID="AccordionCtrl" RequireOpenedPane="False" SelectedIndex="0" runat="server"
        HeaderCssClass="accordionMenuHeader" HeaderSelectedCssClass="accordionMenuHeaderSelected" ContentCssClass="accordionMenuContent" TransitionDuration="250" meta:resourcekey="AccordionCtrlResource1">
        <Panes>
            <ajaxToolkit:AccordionPane runat="server" ID="acpFlight" meta:resourcekey="acpFlightResource1">
                <Content>
                    <asp:FormView ID="fmvLE" runat="server" OnDataBound="fmvLE_DataBound" Width="100%" meta:resourcekey="fmvLEResource1">
                        <ItemTemplate>
                            <p>
                                <span style="font-size:larger; font-weight: bold;">
                                <%# ((DateTime) Eval("Date")).ToShortDateString() %> - 
                                <%# Eval("TailNumDisplay") %>
                                <asp:MultiView ID="mvCatClass" runat="server" ActiveViewIndex='<%# Convert.ToBoolean(Eval("IsOverridden")) ? 1 : 0 %>'>
                                    <asp:View ID="vwDefaultCatClass" runat="server">
                                        (<%# Eval("CatClassDisplay") %>)
                                    </asp:View>
                                    <asp:View ID="vwOverriddenCatClass" runat="server">
                                        (<asp:Label ID="lblCatClass" runat="server" Text='<%# Eval("CatClassDisplay") %>' CssClass="ExceptionData" meta:resourcekey="lblCatClassResource1"></asp:Label>)
                                    </asp:View>
                                </asp:MultiView>
                                </span>
                                <span style="white-space:pre-line;"><%# Eval("CommentWithReplacedApproaches") %>&nbsp;</span></p>
                            <div>
                                <uc1:mfbTooltip ID="mfbTTCatClass" runat="server" BodyContent="<%$ Resources:LogbookEntry, LogbookAltCatClassTooltip %>" HoverControl="lblCatClass" />
                            </div>
                            <asp:Panel ID="pnlRoute" runat="server" Visible="<%# RoutesList.MasterList.GetNormalizedAirports().Length > 0 %>" CssClass="detailsSection" meta:resourcekey="pnlRouteResource1">
                                <h3><%# Eval("Route").ToString().ToUpper() %></h3>
                                <uc5:mfbAirportServices runat="server" ID="mfbAirportServices1" ShowZoom="true" ShowInfo="true" ShowMetar="true" />
                                <p><%# ((LogbookEntryDisplay) Container.DataItem).GetPathDistanceDescription(DataForFlight.ComputePathDistance()) %></p>
                                <asp:Panel ID="pnlMetars" runat="server" Visible='<%# util.GetIntParam(Request, "metar", 0) != 0 %>'>
                                    <asp:Button ID="btnMetars" runat="server" Text="<%$ Resources:Weather, GetMETARSPrompt %>" OnClick="btnMetars_Click" />
                                    <uc1:METAR runat="server" ID="METARDisplay" />
                                </asp:Panel>
                            </asp:Panel>
                            <div class="detailsSection">
                                <table cellpadding="3px;">
                                    <tr>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldApproaches %></td>
                                        <td style="min-width: 1cm"><%# Eval("Approaches").FormatInt() %></td>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldHold %></td>
                                        <td style="min-width: 1cm"><%# Eval("fHoldingProcedures").FormatBoolean() %></td>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldLanding %></td>
                                        <td style="min-width: 1cm"><%# Eval("Landings").FormatInt() %></td>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldDayLandings %></td>
                                        <td style="min-width: 1cm"><%# Eval("FullStopLandings").FormatInt() %></td>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldNightLandings %></td>
                                        <td style="min-width: 1cm"><%# Eval("NightLandings").FormatInt() %></td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldXCountry %></td>
                                        <td><%# Eval("CrossCountry").FormatDecimal(Viewer.UsesHHMM)%></td>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldNight %></td>
                                        <td><%# Eval("Nighttime").FormatDecimal(Viewer.UsesHHMM)%></td>
                                        <td style="font-weight: bold"><% = Resources.Totals.SimIMC %></td>
                                        <td><%# Eval("SimulatedIFR").FormatDecimal(Viewer.UsesHHMM)%></td>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldIMC %></td>
                                        <td><%# Eval("IMC").FormatDecimal(Viewer.UsesHHMM)%></td>
                                        <td style="font-weight: bold"><% = Resources.Totals.Ground %></td>
                                        <td><%# Eval("GroundSim").FormatDecimal(Viewer.UsesHHMM)%></td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldDual %></td>
                                        <td><%# Eval("Dual").FormatDecimal(Viewer.UsesHHMM)%></td>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldCFI %></td>
                                        <td><%# Eval("CFI").FormatDecimal(Viewer.UsesHHMM)%></td>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldSIC %></td>
                                        <td><%# Eval("SIC").FormatDecimal(Viewer.UsesHHMM)%></td>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldPIC %></td>
                                        <td><%# Eval("PIC").FormatDecimal(Viewer.UsesHHMM)%></td>
                                        <td style="font-weight: bold"><% = Resources.LogbookEntry.FieldTotal %></td>
                                        <td><%# Eval("TotalFlightTime").FormatDecimal(Viewer.UsesHHMM)%></td>
                                    </tr>
                                </table>
                                <div style="white-space:pre-line"><%#: Eval("CustPropertyDisplay").ToString() %></div>
                                <div><%# Eval("EngineTimeDisplay") %></div>
                                <div><%# Eval("FlightTimeDisplay") %></div>
                                <div><%# Eval("HobbsDisplay") %></div>
                            </div>
                            <asp:Panel ID="pnlSignature" CssClass="detailsSection" runat="server" Visible='<%# ((LogbookEntry.SignatureState) Eval("CFISignatureState")) != LogbookEntry.SignatureState.None %>' meta:resourcekey="pnlSignatureResource1">
                                <uc1:mfbSignature runat="server" ID="mfbSignature" />
                            </asp:Panel>
                            <div style="text-align:center">
                                <uc1:mfbImageList ID="mfbilFlight" runat="server" Columns="2" MapLinkType="ZoomOnLocalMap" CanEdit="false" MaxImage="-1" ImageClass="Flight" IncludeDocs="false" />
                            </div>
                            <div><uc1:mfbVideoEntry runat="server" ID="mfbVideoEntry1" CanAddVideos="false" /></div>
                            <input id="btnEdit" type="button" value="<%$ Resources:LogbookEntry, PublicFlightEditThisFlight %>" runat="server"
                                visible='<%# ((String) Eval("User")).CompareCurrentCultureIgnoreCase(Page.User.Identity.Name) == 0 %>'
                                style="float: right" 
                                onclick='<%# String.Format(System.Globalization.CultureInfo.InvariantCulture, "javascript:window.location.href=\"{0}\"", ResolveClientUrl(String.Format(System.Globalization.CultureInfo.InvariantCulture, "~/Member/LogbookNew.aspx/{0}", Eval("FlightID")))) %>' />
                        </ItemTemplate>
                    </asp:FormView>
                </Content>
            </ajaxToolkit:AccordionPane>
            <ajaxToolkit:AccordionPane runat="server" ID="acpAircraft" meta:resourcekey="acpAircraftResource1">
                <Content>
                    <asp:FormView ID="fmvAircraft" runat="server" Width="100%" OnDataBound="fmvAircraft_DataBound" meta:resourcekey="fmvAircraftResource1">
                        <ItemTemplate>
                            <table cellpadding="5px">
                                <tr>
                                    <td>
                                        <uc1:mfbHoverImageList runat="server" ID="mfbHoverImageList" ImageListKey='<%# Eval("AircraftID") %>'
                                            ImageListAltText='<%# Eval("TailNumber") %>' MaxWidth="150px" ImageListDefaultImage='<%# Eval("DefaultImage") %>'
                                            ImageListDefaultLink='<%# String.Format(System.Globalization.CultureInfo.InvariantCulture, "~/Member/EditAircraft.aspx?id={0}", Eval("AircraftID")) %>' ImageClass="Aircraft" CssClass="activeRow" />
                                    </td>
                                    <td>
                                        <asp:Panel ID="pnlAircraftID" runat="server" meta:resourcekey="pnlAircraftIDResource1">
                                            <div>
                                                <asp:HyperLink ID="lnkEditAircraft" Font-Size="Larger" Font-Bold="True" runat="server" NavigateUrl='<%# String.Format(System.Globalization.CultureInfo.InvariantCulture, "~/Member/EditAircraft.aspx?id={0}", Eval("AircraftID")) %>' meta:resourcekey="lnkEditAircraftResource1" Text='<%# Eval("DisplayTailNumber") %>'></asp:HyperLink>
                                                - <%# Eval("ModelDescription")%> - <%# Eval("ModelCommonName")%> (<%# Eval("CategoryClassDisplay") %>)
                                            </div>
                                            <div><%# Eval("InstanceTypeDescription")%></div>
                                        </asp:Panel>
                                        <asp:Panel ID="pnlAircraftDetails" runat="server" CssClass="activeRow" meta:resourcekey="pnlAircraftDetailsResource1">
                                            <div style="white-space: pre"><%# Eval("PublicNotes").ToString().Linkify() %></div>
                                            <div style="white-space: pre"><%# Eval("PrivateNotes").ToString().Linkify() %></div>
                                            <asp:Panel ID="pnlAttributes" runat="server" meta:resourcekey="pnlAttributesResource1">
                                                <ul>
                                                    <asp:Repeater ID="rptAttributes" runat="server" DataSource='<%# MakeModel.GetModel((int) Eval("ModelID")).AttributeList() %>'>
                                                        <ItemTemplate>
                                                            <li><%# Container.DataItem %></li>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </ul>
                                            </asp:Panel>
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                    </asp:FormView>
                </Content>
            </ajaxToolkit:AccordionPane>
            <ajaxToolkit:AccordionPane runat="server" ID="acpChart" meta:resourcekey="acpChartResource1">
                <Content>
                    <div style="width: 90%; margin-left: 5%; margin-right: 5%; text-align: center;">
                        <asp:Localize ID="locDataToChart" runat="server" Text="Data to chart:" meta:resourcekey="locDataToChartResource1"></asp:Localize>
                        <br />
                        <asp:DropDownList ID="cmbYAxis1" runat="server" AutoPostBack="True"
                            OnSelectedIndexChanged="cmbYAxis1_SelectedIndexChanged" meta:resourcekey="cmbYAxis1Resource1">
                        </asp:DropDownList><br />
                        <asp:Localize ID="locY2AxisSelection" runat="server" Text="2nd data to chart:" meta:resourcekey="locY2AxisSelectionResource1"></asp:Localize><br />
                        <asp:DropDownList ID="cmbYAxis2" runat="server" AutoPostBack="True"
                            OnSelectedIndexChanged="cmbYAxis2_SelectedIndexChanged" meta:resourcekey="cmbYAxis2Resource1">
                        </asp:DropDownList><br />
                        <asp:Localize ID="locXAxisSelection" runat="server" Text="X-axis:" meta:resourcekey="locXAxisSelectionResource1"></asp:Localize><br />
                        <asp:DropDownList ID="cmbXAxis" runat="server" AutoPostBack="True"
                            OnSelectedIndexChanged="cmbXAxis_SelectedIndexChanged" meta:resourcekey="cmbXAxisResource1">
                        </asp:DropDownList>
                        <br />
                        <uc2:GoogleChart ID="gcData" SlantAngle="0" LegendType="bottom" Width="800" Height="500" runat="server" />
                    </div>
                    <div>
                        <asp:Label ID="lblMinY" runat="server" meta:resourcekey="lblMinYResource1"></asp:Label></div>
                    <div>
                        <asp:Label ID="lblMaxY" runat="server" meta:resourcekey="lblMaxYResource1"></asp:Label></div>
                    <div>
                        <asp:Label ID="lblMinY2" runat="server" meta:resourcekey="lblMinY2Resource1"></asp:Label></div>
                    <div>
                        <asp:Label ID="lblMaxY2" runat="server" meta:resourcekey="lblMaxY2Resource1"></asp:Label></div>
                </Content>
            </ajaxToolkit:AccordionPane>
            <ajaxToolkit:AccordionPane runat="server" ID="acpRaw" meta:resourcekey="acpRawResource1">
                <Content>
                    <asp:Panel ID="Panel1" runat="server"
                        Style="width: 90%; text-align: center; margin-left: 5%; margin-right: 5%; background-color: #DDDDDD; border: solid 1px gray;"
                        Height="400px" ScrollBars="Auto" meta:resourcekey="Panel1Resource1">
                        <asp:GridView ID="gvData" runat="server" CellPadding="3" EnableViewState="False"
                            OnRowDataBound="OnRowDatabound" meta:resourcekey="gvDataResource1">
                            <Columns>
                                <asp:TemplateField meta:resourcekey="TemplateFieldResource1">
                                    <ItemTemplate>
                                        <asp:Image ID="imgPin" Height="20px" runat="server"
                                            ImageUrl="~/Images/Pushpinsm.png" meta:resourcekey="imgPinResource1" />
                                        <asp:HyperLink
                                            ID="lnkZoom" runat="server" Text="<%$ Resources:FlightData, ZoomIn %>" meta:resourcekey="lnkZoomResource1"></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Position" meta:resourcekey="TemplateFieldResource2">
                                    <ItemTemplate>
                                        <%# ((MyFlightbook.Geography.LatLong) Eval("Position")).ToDegMinSecString() %>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </Content>
            </ajaxToolkit:AccordionPane>
            <ajaxToolkit:AccordionPane runat="server" ID="acpDownload" meta:resourcekey="acpDownloadResource1">
                <Content>
                    <table style="margin-left:auto; margin-right:auto;">
                        <tr>
                            <td>
                                <asp:Localize ID="locDownloadPrompt" runat="server"
                                                            Text="Download this data as:" meta:resourcekey="locDownloadPromptResource1"></asp:Localize>
                            </td>
                            <td>
                                <asp:DropDownList ID="cmbFormat" runat="server" meta:resourcekey="cmbFormatResource1" onchange="javascript:showUnitConvert(this);">
                                    <asp:ListItem Selected="True" Value="Original" Text="Original Format" meta:resourcekey="ListItemResource1"></asp:ListItem>
                                    <asp:ListItem Value="CSV" Text="Text (CSV / Spreadsheet)" meta:resourcekey="ListItemResource2"></asp:ListItem>
                                    <asp:ListItem Enabled="False" Value="KML" Text="KML (Google Earth)" meta:resourcekey="ListItemResource3"></asp:ListItem>
                                    <asp:ListItem Enabled="False" Value="GPX" Text="GPX" meta:resourcekey="ListItemResource4"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr id="rowUnitConvert1" style="visibility:hidden;">
                            <td>
                                <asp:Localize ID="locSpeedUnitsPrompt" runat="server" Text="Speed in original data is:" meta:resourcekey="locSpeedUnitsPromptResource1"></asp:Localize>
                            </td>
                            <td>
                                <asp:DropDownList ID="cmbSpeedUnits" runat="server" meta:resourcekey="cmbSpeedUnitsResource1">
                                    <asp:ListItem Selected="True" Value="0" Text="Knots" meta:resourcekey="ListItemResource5"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Miles/Hour" meta:resourcekey="ListItemResource6"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Meters/Second" meta:resourcekey="ListItemResource7"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Feet/Second" meta:resourcekey="ListItemResource8"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr id="rowUnitConvert2" style="visibility:hidden;">
                            <td>
                                <asp:Localize ID="locAltUnitsPrompt" runat="server" Text="Altitude in original data is:" meta:resourcekey="locAltUnitsPromptResource1"></asp:Localize>
                            </td>
                            <td>
                                <asp:DropDownList ID="cmbAltUnits" runat="server" meta:resourcekey="cmbAltUnitsResource1">
                                    <asp:ListItem Selected="True" Value="0" Text="Feet" meta:resourcekey="ListItemResource9"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Meters" meta:resourcekey="ListItemResource10"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr><td>&nbsp;</td><td></td></tr>
                        <tr><td></td><td><asp:Button ID="btnDownload" runat="server" CausesValidation="False" OnClick="btnDownload_Click"
                        Text="Download" meta:resourcekey="btnDownloadResource1" /></td></tr>
                    </table>
                </Content>
            </ajaxToolkit:AccordionPane>
        </Panes>
    </ajaxToolkit:Accordion>
    <asp:Panel ID="pnlErrors" runat="server" Visible="False" CssClass="callout"
        Style="width: 90%; margin-left: 5%; margin-right: 5%; text-align: center;" meta:resourcekey="pnlErrorsResource1">
        <span style="text-align: center; font-weight: bold">
            <asp:Localize ID="locErrorsFound" runat="server"
                Text="Errors were found in loading flight data" meta:resourcekey="locErrorsFoundResource1"></asp:Localize>
            <asp:Label ID="lblShowerrors" CssClass="error" runat="server" meta:resourcekey="lblShowerrorsResource1"></asp:Label></span>
        <asp:Panel ID="pnlErrorDetail" runat="server"
            Style="height: 0px; overflow: hidden" meta:resourcekey="pnlErrorDetailResource1">
            <asp:Label ID="lblErr" runat="server" meta:resourcekey="lblErrResource1"></asp:Label>
            <cc1:CollapsiblePanelExtender
                ID="CollapsiblePanelExtender1" runat="server" Collapsed="True" TargetControlID="pnlErrorDetail"
                CollapseControlID="lblShowerrors" ExpandControlID="lblShowerrors"
                CollapsedText="<%$ Resources:LocalizedText, ClickToShow %>" ExpandedText="<%$ Resources:LocalizedText, ClickToHide %>"
                TextLabelID="lblShowerrors" BehaviorID="CollapsiblePanelExtender1"></cc1:CollapsiblePanelExtender>
        </asp:Panel>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnlMap" Style="width: 80%; margin-left: 10%; margin-right: 10%;" meta:resourcekey="pnlMapResource1">
        <asp:Panel ID="pnlMapControls" runat="server">
        <asp:HyperLink ID="lnkZoomToFit" runat="server"
            Text="Zoom to fit all flight data" meta:resourcekey="lnkZoomToFitResource1"></asp:HyperLink>&nbsp;|&nbsp;<asp:LinkButton
                ID="lnkClearEvents" runat="server"
                OnClick="lnkClearEvents_Click" Text="Clear added markers" meta:resourcekey="lnkClearEventsResource1"></asp:LinkButton>
        </asp:Panel>
        <uc1:mfbGoogleMapManager ID="mfbGoogleMapManager1" runat="server" AllowResize="false" Height="600px" />
    </asp:Panel>
    <asp:HiddenField ID="hdnFlightID" runat="server" />
</asp:Content>

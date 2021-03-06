﻿<%@ Control Language="C#" AutoEventWireup="true" CodeFile="mfbLogbook.ascx.cs" Inherits="Controls_mfbLogbook" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="mfbImageList.ascx" TagName="mfbImageList" TagPrefix="uc1" %>
<%@ Register src="mfbMiniFacebook.ascx" tagname="mfbMiniFacebook" tagprefix="uc2" %>
<%@ Register src="mfbTweetThis.ascx" tagname="mfbTweetThis" tagprefix="uc4" %>
<%@ Register src="mfbDecimalEdit.ascx" tagname="mfbDecimalEdit" tagprefix="uc6" %>
<%@ Register src="popmenu.ascx" tagname="popmenu" tagprefix="uc7" %>
<%@ Register src="mfbTooltip.ascx" tagname="mfbTooltip" tagprefix="uc5" %>
<%@ Register Src="~/Controls/mfbTooltip.ascx" TagPrefix="uc1" TagName="mfbTooltip" %>

<div class="printonly">
    <div>
        <asp:Label ID="lblLogbookHeader" runat="server" Text=""><% = Pilot.UserFullName %></asp:Label>
    </div>
    <div>
        <asp:Panel ID="pnlAddress" runat="server"><asp:Label ID="lblAddress" runat="server" Text="" style="white-space: pre-wrap"></asp:Label></asp:Panel>
    </div>
</div>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <asp:Panel ID="pnlHeader" runat="server">
            <table>
                <tr>
                    <td><asp:Label ID="lblNumFlights" runat="server"></asp:Label></td>
                    <td>
                        <span class="noprint">
                            <uc7:popmenu ID="popmenuHeader" runat="server">
                                <MenuContent>
                                    <div><asp:RadioButton ID="rblShowInPages" runat="server" AutoPostBack="true" OnCheckedChanged="lnkShowInPages_Click" Text="<%$ Resources:LogbookEntry, LogbookShowInPages %>" GroupName="rblPagingGroup" /></div>
                                    <div><asp:RadioButton ID="rblShowAll" runat="server" AutoPostBack="true" OnCheckedChanged="lnkShowAll_Click" CausesValidation="false" Text="<%$ Resources:LogbookEntry, LogbookShowAll %>" GroupName="rblPagingGroup" /></div>
                                    <div><asp:CheckBox ID="ckCompactView" runat="server" Text="<%$ Resources:LogbookEntry, LogbookCompactView %>" CausesValidation="false" AutoPostBack="true" OnCheckedChanged="ckCompactView_CheckedChanged" /></div>
                                    <div><asp:CheckBox ID="ckIncludeImages" runat="server" Text="<%$ Resources:LogbookEntry, LogbookIncludeImages %>" CausesValidation="false" AutoPostBack="true" OnCheckedChanged="ckIncludeImages_CheckedChanged" /></div>
                                </MenuContent>
                            </uc7:popmenu>
                        </span>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <asp:Image ID="imgProgress" ImageUrl="~/images/ajax-loader.gif" runat="server" />
            </ProgressTemplate>
        </asp:UpdateProgress>
        <div style="margin-left: 5px; margin-right: 5px">
            <asp:GridView ID="gvFlightLogs" runat="server" AutoGenerateColumns="False" BorderStyle="None"
            CellPadding="3" DataKeyNames="FlightID" AllowSorting="True" 
            ShowHeader="true" ShowFooter="true" UseAccessibleHeader="true" Width="100%"
            Font-Size="8pt" AllowPaging="True"
            OnRowDataBound="gvFlightLogs_RowDataBound" EnableViewState="false" 
            PagerSettings-Mode="NumericFirstLast"
            GridLines="None" OnDataBound="gvFlightLogs_DataBound" 
            OnRowCommand="gvFlightLogs_RowCommand" OnSorting="gvFlightLogs_Sorting" 
            OnPageIndexChanging="gridView_PageIndexChanging">
            <Columns>
                <asp:TemplateField HeaderText="<%$ Resources:LogbookEntry, FieldFlight %>" SortExpression="Date">
                    <HeaderStyle CssClass="headerBase headerSortDesc" HorizontalAlign="Left" />
                    <ItemTemplate>
                        <div class="noprint" style="float:right">
                            &nbsp;&nbsp;
                            <asp:Panel ID="pnlImagesHover" runat="server" Visible="false" style="display:inline-block;">
                                <asp:HyperLink ID="lnkViewPublic" NavigateUrl='<%# PublicPath(Eval("FlightID")) %>' runat="server">
                                    <asp:Image ID="imgCamera" ImageUrl="~/Images/camera.png" runat="server" Visible="<%# !ShowImagesInline %>"
                                        ToolTip="<%$ Resources:LogbookEntry, LogbookFlightHasPicturesTooltip %>"
                                        AlternateText="<%$ Resources:LogbookEntry, LogbookFlightHasPicturesTooltip %>" />
                                    <cc1:HoverMenuExtender ID="hoverMenuImages" TargetControlID="imgCamera" Enabled="<%# !ShowImagesInline %>" PopupControlID="pnlFlightImages" OffsetX="20" OffsetY="-100" runat="server"></cc1:HoverMenuExtender>
                                </asp:HyperLink>
                            </asp:Panel>
                            <asp:HyperLink ID="lnkViewflightData" runat="server" Visible='<%# Convert.ToBoolean(Eval("HasFlightData")) %>' NavigateUrl='<%# AnalyzePath(Eval("FlightID")) %>'>
                                <asp:Image ID="imgViewFlightData" ImageUrl="~/images/Clip.png" AlternateText="<%$ Resources:LogbookEntry, LogbookFlightHasTelemetry %>" ToolTip="<%$ Resources:LogbookEntry, LogbookFlightHasTelemetry %>" runat="server" /></asp:HyperLink>
                        </div>
                        <div>
                            <asp:HyperLink ID="lnkEditFlight" Font-Bold="true" runat="server" Text='<%# ((DateTime) Eval("Date")).ToShortDateString() %>' Font-Size="Larger" NavigateUrl='<%# DetailsPath(Eval("FlightID")) %>'></asp:HyperLink>
                            <asp:HyperLink Font-Bold="true" ID="lnkRoute" runat="server" Text='<%#: Eval("Route") %>' NavigateUrl='<%# PublicPath(Eval("FlightID")) %>'></asp:HyperLink>
                            <span runat="server" id="divComments" style="clear:left; white-space: pre-line;" dir="auto"><asp:Label ID="lblComments" runat="server" Text='<%# Eval("CommentWithReplacedApproaches") %>'></asp:Label></span>
                            <span class="noprint"><asp:Image ID="imgExpandProps" runat="server" Visible='<%# IsCompact && ((LogbookEntryDisplay) Container.DataItem).PropertiesWithReplacedApproaches.Count() > 0 %>' ImageUrl="~/images/expand.png" /></span>
                        </div>
                        <cc1:CollapsiblePanelExtender ID="cpeDisplayMode" runat="server" Collapsed='<%# IsCompact %>' Enabled='<%# IsCompact && ((LogbookEntryDisplay) Container.DataItem).PropertiesWithReplacedApproaches.Count() > 0  %>'
                            TargetControlID="pnlProps" CollapsedImage="~/images/expand.png" ExpandedImage="~/images/collapse.png" CollapseControlID="imgExpandProps" ExpandControlID="imgExpandProps" ImageControlID="imgExpandProps" />
                        <asp:Panel ID="pnlFlightTimes" runat="server" Visible="<%# Viewer.DisplayTimesByDefault %>">
                            <asp:Panel ID="pnlEngineTime" runat="server">
                                <%# Eval("EngineTimeDisplay") %>
                            </asp:Panel>
                            <asp:Panel ID="pnlFlightTime" runat="server">
                                <%# Eval("FlightTimeDisplay") %>
                            </asp:Panel>
                            <asp:Panel ID="pnlHobbs" runat="server">
                                <%# Eval("HobbsDisplay") %>
                            </asp:Panel>
                        </asp:Panel>
                        <asp:Panel ID="pnlProps" runat="server">
                            <asp:Repeater ID="rptProps" runat="server" DataSource='<%# Eval("PropertiesWithReplacedApproaches") %>'>
                                <ItemTemplate>
                                    <div><%# Container.DataItem %></div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </asp:Panel>
                        <asp:Panel ID="pnlSignature" CssClass="signatureBlock" runat="server" Visible='<%# ((LogbookEntry.SignatureState) Eval("CFISignatureState")) != LogbookEntry.SignatureState.None %>'>
                            <div style="display: inline-block; vertical-align:middle;">
                                <table>
                                    <tr>
                                        <td style="vertical-align:middle">
                                            <asp:HyperLink ID="lnkImageSig" runat="server" NavigateUrl='<%# ((bool) Eval("HasDigitizedSig")) ? String.Format("~/Public/ViewSig.aspx?id={0}", Eval("FlightID")) : string.Empty %>'>
                                                <asp:Image ID="imgSigState" ToolTip='<%# Eval("SignatureStateDescription") %>' AlternateText='<%# Eval("SignatureStateDescription") %>' ImageUrl='<%# ((bool) Eval("HasValidSig")) ? "~/Images/sigok.png" : "~/Images/siginvalid.png" %>' ImageAlign="Middle" runat="server" />
                                            </asp:HyperLink>
                                            <cc1:HoverMenuExtender ID="HoverMenuExtender1" TargetControlID="imgSigState" PopupControlID="pnlSigState" OffsetX="10" OffsetY="10" runat="server"></cc1:HoverMenuExtender>
                                            <asp:Panel ID="pnlSigState" runat="server" CssClass="hintPopup" Visible='<%# Convert.ToBoolean(Eval("HasDigitizedSig")) %>'>
                                                <asp:Image ID="imgDigitizedSig" runat="server" ImageUrl='<%# String.Format("~/Public/ViewSig.aspx?id={0}", Eval("FlightID")) %>' />
                                            </asp:Panel>
                                        </td>
                                        <td style="vertical-align:middle">
                                            <asp:Label ID="lblSigData" runat="server"
                                                CssClass='<%# ((bool) Eval("HasValidSig")) ? "signatureValid" : "signatureInvalid" %>'>
                                                <div><%#: ((string) Eval("SignatureMainLine")) %></div>
                                                <div><%#: Eval("SignatureCommentLine") %></div>
                                            </asp:Label>
                                            <asp:Panel ID="pnlInvalidSig" runat="server" Visible='<%# !(bool) Eval("HasValidSig") %>'>
                                                <asp:Label ID="lblSigInvalid" runat="server" Font-Bold="true" CssClass="signatureInvalid" Text="<%$ Resources:SignOff, FlightSignatureInvalid %>"></asp:Label>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>
                        <asp:Panel ID="pnlFlightImages" runat="server" CssClass='<%# ShowImagesInline ? string.Empty : "hintPopup" %>'>
                            <uc1:mfbImageList ID="mfbilFlights" runat="server" Columns="2" CanEdit="false" ImageClass="Flight" IncludeDocs="false" MaxImage="-1" />
                        </asp:Panel>
                    </ItemTemplate>
                    <FooterTemplate>
                        <table style="width:100%">
                            <tr>
                                <td style="width:70%"><%# Pilot.UserFullName %></td>
                                <td><asp:Label ID="lblCertificate" runat="server" Text="<%# Pilot.LicenseDisplay %>"></asp:Label></td>
                            </tr>
                            <tr>
                                <td><asp:Localize ID="locCertification" Text="<%$ Resources:LogbookEntry, LogbookCertification %>" runat="server"></asp:Localize></td>
                                <td><asp:Label ID="lblCFICertificate" runat="server" Text="<%# Pilot.CFIDisplay %>"></asp:Label></td>
                            </tr>
                        </table>
                    </FooterTemplate>
                    <FooterStyle CssClass="printonly" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="<%$ Resources:LogbookEntry, FieldTail %>" SortExpression="TailNumDisplay">
                    <ItemStyle HorizontalAlign="Center" />
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:HyperLink ID="lnkTail" NavigateUrl='<%# String.Format("~/Member/EditAircraft.aspx?id={0}", Eval("AircraftID")) %>' runat="server">
                            <asp:Label ID="lblTail" runat="server" Text='<%# Eval("TailNumDisplay") %>'></asp:Label>
                        </asp:HyperLink>
                        <cc1:HoverMenuExtender ID="hoverTail" TargetControlID="lblTail" PopupControlID="pnlTailImages" OffsetX="50" OffsetY="-60" runat="server"></cc1:HoverMenuExtender>
                        <asp:Panel ID="pnlTailImages" CssClass="hintPopup" runat="server">
                            <div style="text-align:center">
                                <%# Eval("ModelDisplay") %> <%# Eval("CatClassDisplay") %> 
                                <asp:PlaceHolder ID="plcAircraftImages" runat="server">

                                </asp:PlaceHolder>
                            </div>
                            <asp:PlaceHolder ID="plcTail" runat="server"></asp:PlaceHolder>
                        </asp:Panel>
                        <span class="printonly">
                            <div><%# Eval("ModelDisplay") %></div>
                            <div><asp:Label ID="lblInstanceTypeDesc" runat="server" Text=""></asp:Label></div>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="<%$ Resources:LogbookEntry, FieldCatClassType %>" SortExpression="CatClassDisplay">
                    <ItemStyle HorizontalAlign="Center" />
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:MultiView ID="mvCatClass" runat="server" ActiveViewIndex='<%# Convert.ToBoolean(Eval("IsOverridden")) ? 1 : 0 %>'>
                            <asp:View ID="vwDefaultCatClass" runat="server">
                                <%# Eval("CatClassDisplay") %>
                            </asp:View>
                            <asp:View ID="vwOverriddenCatClass" runat="server">
                                <asp:Label ID="lblCatClass" runat="server" Text='<%# Eval("CatClassDisplay") %>' CssClass="ExceptionData">
                                </asp:Label>
                                <uc5:mfbTooltip ID="mfbTTCatClass" runat="server" BodyContent="<%$ Resources:LogbookEntry, LogbookAltCatClassTooltip %>" HoverControl="lblCatClass" />
                            </asp:View>
                        </asp:MultiView>
                        <div class="printonly"><asp:Label ID="lblModelAttributes" runat="server" Text='<%# MakeModel.GetModel(Convert.ToInt32(Eval("ModelID"))).AttributeListSingleLine %>'></asp:Label></div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="<%$ Resources:LogbookEntry, FieldApproaches %>" SortExpression="Approaches">
                    <ItemStyle HorizontalAlign="Center" />
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemTemplate>
                        <%# Eval("Approaches").FormatInt() %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="<%$ Resources:LogbookEntry, FieldHold %>" SortExpression="fHoldingProcedures">
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemStyle Font-Bold="true" Font-Size="Larger" HorizontalAlign="Center" />
                    <ItemTemplate>
                        <%# Eval("fHoldingProcedures").FormatBoolean() %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="<%$ Resources:LogbookEntry, FieldLanding %>" SortExpression="Landings">
                    <HeaderTemplate>
                        <asp:LinkButton ID="lnkLandings" runat="server" CommandName="Sort" CommandArgument="Landings" Text="<%$ Resources:LogbookEntry, FieldLanding %>"></asp:LinkButton>
                        <span class="noprint" style="font-weight:normal;">
                            <uc5:mfbTooltip ID="mfbTooltip1" runat="server" BodyContent="<%$ Resources:LogbookEntry, LogbookLandingKey %>" />
                        </span>
                    </HeaderTemplate>
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <%# Eval("LandingDisplay") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField  HeaderText="<%$ Resources:LogbookEntry, FieldXCountry %>" SortExpression="CrossCountry">
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <%# Eval("CrossCountry").FormatDecimal(Viewer.UsesHHMM)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField  HeaderText="<%$ Resources:LogbookEntry, FieldNight %>" SortExpression="Nighttime">
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <%# Eval("Nighttime").FormatDecimal(Viewer.UsesHHMM)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField  HeaderText="<%$ Resources:LogbookEntry, FieldSimIMC %>" SortExpression="SimulatedIFR">
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <%# Eval("SimulatedIFR").FormatDecimal(Viewer.UsesHHMM)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField  HeaderText="<%$ Resources:LogbookEntry, FieldIMC %>" SortExpression="IMC">
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <%# Eval("IMC").FormatDecimal(Viewer.UsesHHMM)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField  HeaderText="<%$ Resources:LogbookEntry, FieldGroundSim %>" SortExpression="GroundSim">
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <%# Eval("GroundSim").FormatDecimal(Viewer.UsesHHMM)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField  HeaderText="<%$ Resources:LogbookEntry, FieldDual %>" SortExpression="Dual">
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <%# Eval("Dual").FormatDecimal(Viewer.UsesHHMM)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField  HeaderText="<%$ Resources:LogbookEntry, FieldCFI %>" SortExpression="CFI">
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <%# Eval("CFI").FormatDecimal(Viewer.UsesHHMM)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField  HeaderText="<%$ Resources:LogbookEntry, FieldSIC %>" SortExpression="SIC">
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <%# Eval("SIC").FormatDecimal(Viewer.UsesHHMM)%>
                    </ItemTemplate>
                </asp:TemplateField>            
                 <asp:TemplateField  HeaderText="<%$ Resources:LogbookEntry, FieldPIC %>" SortExpression="PIC">
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <%# Eval("PIC").FormatDecimal(Viewer.UsesHHMM)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="<%$ Resources:LogbookEntry, FieldTotal %>" SortExpression="TotalFlightTime">
                    <HeaderStyle CssClass="headerBase" HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Right" />
                    <ItemTemplate>
                        <%# Eval("TotalFlightTime").FormatDecimal(Viewer.UsesHHMM)%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemStyle CssClass="noprint" />
                    <ItemTemplate>
                        <uc7:popmenu ID="popmenu1" runat="server" Visible="<%# IsViewingOwnFlights %>" OffsetX="-160">
                            <MenuContent>
                                <div><uc2:mfbMiniFacebook ID="mfbMiniFacebook" runat="server" /></div>
                                <div><uc4:mfbTweetThis ID="mfbTweetThis" runat="server" /></div>
                                <div>
                                    <asp:HyperLink ID="lnkEditThisFlight" runat="server">
                                        <asp:Image ID="imgPencil" runat="server" style="padding-right: 4px;" ImageUrl="~/images/pencilsm.png" />
                                        <asp:Label ID="lblEditFlight" runat="server" Text="<%$ Resources:LogbookEntry, PublicFlightEditThisFlight %>"></asp:Label>
                                    </asp:HyperLink>
                                </div>
                                <div>
                                    <asp:HyperLink ID="lnkRequestSignature" runat="server">
                                        <asp:Image ID="imgSignature" runat="server" style="padding-right: 4px" ImageUrl="~/images/signaturesm.png" />
                                        <asp:Label ID="lblRequestSignature" runat="server" Text="<%$ Resources:SignOff, RequestSignature %>"></asp:Label>
                                    </asp:HyperLink>
                                </div>
                                <div>
                                    <asp:LinkButton ID="lnkClone" runat="server" CommandName="CloneFlight">
                                        <asp:Image ID="imgClone" runat="server" style="padding-right:4px;" ImageUrl="~/images/copyflight.png" />
                                        <asp:Label ID="lblClone" runat="server" Text="<%$ Resources:LogbookEntry, RepeatFlight %>"></asp:Label>
                                    </asp:LinkButton>
                                </div>
                                <div>
                                    <asp:LinkButton ID="lnkReverse" runat="server" CommandName="ReverseFlight">
                                        <asp:Image ID="imgReverse" runat="server" style="padding-right:4px;" ImageUrl="~/images/copyflightreverse.png" />
                                        <asp:Label ID="lblReverse" runat="server" Text="<%$ Resources:LogbookEntry, RepeatReverseFlight %>"></asp:Label>
                                    </asp:LinkButton>
                                </div>
                                <div>
                                    <asp:LinkButton ID="lnkSendFlight" runat="server" CommandName="SendFlight">
                                        <asp:Image ID="imgSendFlight" style="padding-right:4px" ImageUrl="~/images/sendflight.png" runat="server" />
                                        <asp:Label ID="lblSendFlight" runat="server" Text="<%$ Resources:LogbookEntry, SendFlight %>"></asp:Label>
                                    </asp:LinkButton>
                                </div>
                            </MenuContent>
                        </uc7:popmenu>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField >
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkDelete" Visible="<%# IsViewingOwnFlights %>" CommandName="_Delete" CommandArgument='<%# Eval("FlightID").ToString() %>' runat="server">
                            <asp:Image ID="imgDelete" ImageUrl="~/images/x.gif" AlternateText="<%$ Resources:LogbookEntry, LogbookDeleteTooltip %>" ToolTip="<%$ Resources:LogbookEntry, LogbookDeleteTooltip %>" runat="server" /></asp:LinkButton>
                        <cc1:ConfirmButtonExtender ID="ConfirmButtonExtender1" runat="server" TargetControlID="lnkDelete" ConfirmOnFormSubmit="True" ConfirmText="<%$ Resources:LogbookEntry, LogbookConfirmDelete %>">
                        </cc1:ConfirmButtonExtender>
                        <asp:HyperLink ID="lnkSignEntry" runat="server"
                            NavigateUrl='<%# String.Format("~/Member/SignFlight.aspx?idFlight={0}&ret={1}", Eval("FlightID"), HttpUtility.UrlEncode(Page.Request.Url.PathAndQuery)) %>'
                            Text='<%# ((LogbookEntry.SignatureState) Eval("CFISignatureState")) == LogbookEntry.SignatureState.Invalid ? Resources.SignOff.LogbookResign : Resources.SignOff.LogbookSign %>' 
                            Visible='<%# !IsViewingOwnFlights && ((LogbookEntry.SignatureState) Eval("CFISignatureState")) != LogbookEntry.SignatureState.Valid %>'></asp:HyperLink>
                    </ItemTemplate>
                    <ItemStyle CssClass="noprint" />
                </asp:TemplateField>
            </Columns>
            <PagerSettings Mode="NextPreviousFirstLast" Position="Bottom" />
            <PagerStyle HorizontalAlign="Center" />
            <AlternatingRowStyle CssClass="logbookAlternateRow" />
            <RowStyle CssClass="logbookRow" />
            <PagerTemplate>
                <asp:Panel ID="pnlPager" runat="server" DefaultButton="btnSetPage" style="font-weight:bold; padding: 5px;">
                    <asp:LinkButton ID="lnkFirst" CommandArgument="First" CommandName="Page" runat="server" Text="<<" CausesValidation="false"></asp:LinkButton>&nbsp;&nbsp;
                    <asp:LinkButton ID="lnkPrev" CommandArgument="Prev" CommandName="Page" runat="server" Text="<" CausesValidation="false" ></asp:LinkButton>&nbsp;&nbsp;
                    <asp:Label ID="lblCurPagePrompt" runat="server" Text="<%$ Resources:LogbookEntry, LogbookPagePrompt %>" Visible="false"></asp:Label> 
                    <asp:TextBox ID="decPage" runat="server" Width="50px" BorderColor="LightGray" BorderStyle="Solid" BorderWidth="1"></asp:TextBox>
                    <span style="font-weight:normal"><uc1:mfbTooltip runat="server" ID="mfbTooltip" BodyContent="<%$ Resources:LogbookEntry, LogbookPagerTip %>" /></span>
                    <asp:Label ID="lblTotalPagePrompt" runat="server" Text="<%$ Resources:LogbookEntry, LogbookPageTotalPagePrompt %>" Visible="false"></asp:Label> <asp:Label ID="lblPage" runat="server" Text="{0}"></asp:Label>
                    <asp:Button ID="btnSetPage" runat="server" Text="<%$ Resources:LogbookEntry, LogbookGoToPage %>" onclick="btnSetPage_Click" style="display:none;" />&nbsp;&nbsp;
                    <asp:LinkButton ID="lnkNext" CommandArgument="Next" CommandName="Page"  runat="server" Text=">" CausesValidation="false" ></asp:LinkButton>&nbsp;&nbsp;
                    <asp:LinkButton ID="lnkLast" CommandArgument="Last" CommandName="Page"  runat="server" Text=">>" CausesValidation="false" ></asp:LinkButton>
                </asp:Panel>
            </PagerTemplate>
            <HeaderStyle HorizontalAlign="Left" VerticalAlign="Bottom" />
            <EmptyDataTemplate>
                <p><%=Resources.LogbookEntry.EmptyLogbook %></p>
            </EmptyDataTemplate>
        </asp:GridView>
        </div>
        <asp:Panel ID="pnlSendFlight" runat="server" Width="480px" DefaultButton="btnSendFlight" CssClass="modalpopup" style="display:none">
            <asp:Localize ID="locSendPrompt" runat="server" Text="<%$ Resources:LogbookEntry, SendFlightPrompt %>"></asp:Localize>
            <asp:HiddenField ID="hdnFlightToSend" runat="server" />
            <table>
                <tr>
                    <td>
                        <asp:Localize ID="locEmailRecipient" runat="server" Text="<%$ Resources:LogbookEntry, SendFlightEmailPrompt %>"></asp:Localize>
                    </td>
                    <td>
                        <asp:TextBox ValidationGroup="valSendFlight" ID="txtSendFlightEmail" Text="" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ValidationGroup="valSendFlight" ID="RequiredFieldValidator2" runat="server" CssClass="error" ErrorMessage="<%$ Resources:LocalizedText, ValidationEmailRequired %>" 
                            ControlToValidate="txtSendFlightEmail" SetFocusOnError="True" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ValidationGroup="valSendFlight" ID="RegularExpressionValidator2" runat="server" CssClass="error"
                            ErrorMessage="<%$ Resources:LocalizedText, ValidationEmailFormat %>" 
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                            ControlToValidate="txtSendFlightEmail" SetFocusOnError="True" Display="Dynamic"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align:top">
                        <asp:Localize ID="locSendFlightMessage" runat="server" Text="<%$ Resources:LogbookEntry, SendFlightMessagePrompt %>"></asp:Localize>
                    </td>
                    <td>
                        <asp:TextBox ValidationGroup="valSendFlight" ID="txtSendFlightMessage" TextMode="MultiLine" Rows="3" runat="server"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <div style="text-align:center">
                <asp:Button ValidationGroup="valSendFlight" ID="btnSendFlight" OnClick="btnSendFlight_Click" runat="server" Text="<%$ Resources:LogbookEntry, SendFlightButton %>" /> <asp:Button ID="btnCancelSend" runat="server" Text="<%$ Resources:LogbookEntry, SendFlightCancel %>" />
            </div>
        </asp:Panel>
        <asp:HyperLink ID="lnkPopSendFlight" runat="server" style="display:none"></asp:HyperLink>
        <uc1:mfbImageList ID="mfbilAircraft" runat="server" Columns="2" CanEdit="false" ImageClass="Aircraft" IncludeDocs="false" MaxImage="2" Visible="false" />
        <cc1:ModalPopupExtender ID="modalPopupSendFlight" runat="server" 
            PopupControlID="pnlSendFlight" TargetControlID="lnkPopSendFlight"
            BackgroundCssClass="modalBackground"
            CancelControlID="btnCancelSend" BehaviorID="modalPopupSendFlight"
            Enabled="true">
        </cc1:ModalPopupExtender>
    </ContentTemplate>
</asp:UpdatePanel>
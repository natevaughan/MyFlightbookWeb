﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="8710Form.aspx.cs" Inherits="Member_8710Form" culture="auto" meta:resourcekey="PageResource1" %>
<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Register Src="../Controls/mfbLogbook.ascx" TagName="mfbLogbook" TagPrefix="uc6" %>
<%@ Register src="../Controls/mfbSearchAndTotals.ascx" tagname="mfbSearchAndTotals" tagprefix="uc1" %>
<%@ Register src="../Controls/mfbSearchForm.ascx" tagname="mfbSearchForm" tagprefix="uc2" %>
<%@ Register src="../Controls/mfbQueryDescriptor.ascx" tagname="mfbQueryDescriptor" tagprefix="uc3" %>
<asp:Content ID="ContentHead" ContentPlaceHolderID="cpPageTitle" runat="server"><asp:Label ID="lblUserName" runat="server" 
            meta:resourcekey="lblUserNameResource1"></asp:Label>
</asp:Content>
<asp:Content ID="ContentTopForm" ContentPlaceHolderID="cpTopForm" runat="server">
    <asp:MultiView ID="mvQuery" runat="server" ActiveViewIndex="0">
        <asp:View ID="vwTotals" runat="server">
            <p class="header"><asp:Localize ID="loc8710DiclaimerHeader" runat="server" 
                    Text="Totals are computed using the criteria below:" 
                    meta:resourcekey="loc8710DiclaimerHeaderResource1"></asp:Localize></p>
            <uc3:mfbQueryDescriptor ID="mfbQueryDescriptor1" runat="server" ShowEmptyFilter="true" OnQueryUpdated="mfbQueryDescriptor1_QueryUpdated" />
            <p class="noprint">
                <asp:Button ID="btnEditQuery" runat="server" onclick="btnEditQuery_Click" 
                    Text="Change Query" meta:resourcekey="btnEditQueryResource1" />
            </p>        
            <asp:GridView ID="gv8710" runat="server" Font-Size="8pt" CellPadding="0" OnRowDataBound="gv8710_RowDataBound"
                AutoGenerateColumns="False" meta:resourcekey="gv8710Resource1">
                <Columns>
                    <asp:BoundField DataField="Category" meta:resourcekey="BoundFieldResource1">
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                        <ItemStyle CssClass="PaddedCell" HorizontalAlign="Center"></ItemStyle>
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Total" meta:resourcekey="TemplateFieldResource1">
                        <ItemTemplate>
                            <%# Eval("TotalTime").FormatDecimal(false) %>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                        <ItemStyle CssClass="PaddedCell" HorizontalAlign="Right"></ItemStyle>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Instruc-<br />tion<br />Received" 
                        meta:resourcekey="TemplateFieldResource2">
                        <ItemTemplate>
                            <%# Eval("InstructionReceived").FormatDecimal(false)%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                        <ItemStyle CssClass="PaddedCell" HorizontalAlign="Right"></ItemStyle>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Solo" meta:resourcekey="TemplateFieldResource3">
                        <ItemTemplate>
                            <%# Eval("SoloTime").FormatDecimal(false)%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                        <ItemStyle CssClass="PaddedCell" HorizontalAlign="Right"></ItemStyle>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="PIC<br />and<br />SIC" 
                        meta:resourcekey="TemplateFieldResource4">
                        <ItemTemplate>
                            <table cellpadding="3px" cellspacing="0" style="width: 100%; font-size:8pt">
                                <tr>
                                    <td style="border-bottom: 1px solid black;">
                                        <asp:Localize ID="locPICMain" runat="server" Text="PIC" meta:resourcekey="locPICMainResource1"></asp:Localize></td>
                                    <td style="border-bottom: 1px solid black;"><%# Eval("PIC").FormatDecimal(false)%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Localize ID="locSICHeaderPIC" runat="server" Text="SIC" meta:resourcekey="locSICHeaderPICResource1"></asp:Localize>
                                    </td>
                                    <td>
                                        <%# Eval("SIC").FormatDecimal(false)%>
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                    </asp:TemplateField>
                    <asp:TemplateField meta:resourcekey="TemplateFieldResource5">
                        <HeaderTemplate>
                            <asp:Localize ID="locCrossCountryDualHeader" runat="server" 
                                meta:resourcekey="locCrossCountryDualHeaderResource1" 
                                Text="Cross&lt;br /&gt;Country&lt;br /&gt;Instruc-&lt;br /&gt;tion&lt;br /&gt;Received"></asp:Localize><span class="FootNote">1</span>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%# Eval("CrossCountryDual").FormatDecimal(false)%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                        <ItemStyle CssClass="PaddedCell" HorizontalAlign="Right"></ItemStyle>
                    </asp:TemplateField>
                    <asp:TemplateField meta:resourcekey="TemplateFieldResource6">
                        <HeaderTemplate>
                            <asp:Localize ID="locXCSoloHeader" runat="server" 
                                meta:resourcekey="locXCSoloHeaderResource1" 
                                Text="Cross&lt;br /&gt;Country&lt;br /&gt;Solo"></asp:Localize><span class="FootNote">1</span>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%# Eval("CrossCountrySolo").FormatDecimal(false)%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                        <ItemStyle CssClass="PaddedCell" HorizontalAlign="Right"></ItemStyle>
                    </asp:TemplateField>
                    <asp:TemplateField meta:resourcekey="TemplateFieldResource7" >
                        <HeaderTemplate>
                            <asp:Localize ID="locXCPICHeader" runat="server" 
                                Text="Cross&lt;br /&gt;Country&lt;br /&gt;PIC/SIC" 
                                meta:resourcekey="locXCPICHeaderResource1"></asp:Localize><span class="FootNote">1</span>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <table cellpadding="3px" cellspacing="0" style="width: 100%; font-size:8pt">
                                <tr>
                                    <td style="border-bottom: 1px solid black;">
                                        <asp:Localize ID="locPICHeader" runat="server" Text="PIC" 
                                            meta:resourcekey="locPICHeaderResource1"></asp:Localize></td>
                                     <td style="border-bottom: 1px solid black;"><%# Eval("CrossCountryPIC").FormatDecimal(false)%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Localize ID="locSICHeaderXCPIC" runat="server" Text="SIC" meta:resourcekey="locSICHeaderXCPICResource1"></asp:Localize></td>
                                    <td><%# Eval("CrossCountrySIC").FormatDecimal(false)%>
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                    </asp:TemplateField>
                    <asp:TemplateField meta:resourcekey="TemplateFieldResource8">
                        <HeaderTemplate>
                            <asp:Localize ID="locInstrumentHeader" runat="server" Text="Instru-&lt;br /&gt;ment" 
                                meta:resourcekey="locInstrumentHeaderResource1"></asp:Localize><span class="FootNote">2</span>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%# Eval("InstrumentTime").FormatDecimal(false)%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                        <ItemStyle CssClass="PaddedCell" HorizontalAlign="Right"></ItemStyle>
                    </asp:TemplateField>
                    <asp:TemplateField meta:resourcekey="TemplateFieldResource9">
                        <HeaderTemplate>
                            <asp:Localize ID="locNightDual" runat="server" 
                                Text="Night&lt;br /&gt;Instruc-&lt;br /&gt;tion&lt;br /&gt;Received" 
                                meta:resourcekey="locNightDualResource1"></asp:Localize><span class="FootNote">1</span>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <%# Eval("NightDual").FormatDecimal(false)%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                        <ItemStyle CssClass="PaddedCell" HorizontalAlign="Right"></ItemStyle>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Night<br />Take-off/<br />Landings" 
                        meta:resourcekey="TemplateFieldResource10">
                        <ItemTemplate>
                            <%# Eval("NightTakeoffs") %>
                            /
                            <%# Eval("NightLandings") %>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField meta:resourcekey="TemplateFieldResource11">
                        <HeaderTemplate><asp:Localize ID="locNightPICHeader" runat="server" 
                                Text="Night PIC/SIC" meta:resourcekey="locNightPICHeaderResource1"></asp:Localize><span class="FootNote">1</span>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <table cellpadding="3px" cellspacing="0" style="width: 100%; font-size:8pt">
                                <tr>
                                    <td style="border-bottom: 1px solid black;">
                                        <asp:Localize ID="locPICNight" runat="server" Text="PIC" 
                                            meta:resourcekey="locPICNightResource1"></asp:Localize>
                                    </td>
                                    <td style="border-bottom: 1px solid black;">
                                        <%# Eval("NightPIC").FormatDecimal(false)%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Localize ID="locSICNight" runat="server" Text="SIC" 
                                            meta:resourcekey="locSICNightResource1"></asp:Localize>
                                    </td>
                                    <td>
                                        <%# Eval("NightSIC").FormatDecimal(false)%>       
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                    </asp:TemplateField>
                    <asp:TemplateField meta:resourcekey="TemplateFieldResource12">
                        <HeaderTemplate><asp:Localize ID="locNightTakeoffLandingHeader" runat="server" 
                                Text="Night&lt;br /&gt;Take-off/&lt;br /&gt;Landing PIC/SIC" 
                                meta:resourcekey="locNightTakeoffLandingHeaderResource1"></asp:Localize><span class="FootNote">3</span></HeaderTemplate>
                        <ItemTemplate>
                            <table cellpadding="3px" cellspacing="0" style="width: 100%; font-size:8pt">
                                <tr>
                                    <td style="border-bottom: 1px solid black;">
                                        <asp:Localize ID="locNightLandingPIC" runat="server" Text="PIC" 
                                            meta:resourcekey="locNightLandingPICResource1"></asp:Localize>
                                    </td>
                                    <td style="border-bottom: 1px solid black;">
                                        <%# Eval("NightPICTakeoffs") %>&nbsp;/&nbsp;<%# Eval("NightPICLandings") %></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Localize ID="locNightLandingSIC" runat="server" Text="SIC" 
                                            meta:resourcekey="locNightLandingSICResource1"></asp:Localize>
                                    </td>
                                    <td>
                                        <%# Eval("NightSICTakeoffs") %>&nbsp;/&nbsp;<%# Eval("NightSICLandings") %></td>
                                </tr>
                            </table>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell"></HeaderStyle>
                    </asp:TemplateField>
                    <asp:TemplateField meta:resourcekey="TemplateFieldResource13" HeaderText="Class Totals">
                        <ItemTemplate>
                            <asp:GridView ID="gvClassTotals" Font-Size="8pt" GridLines="None" ShowHeader="False" BorderStyle="None" runat="server" AutoGenerateColumns="False" meta:resourcekey="gvClassTotalsResource1">
                                <Columns>
                                    <asp:TemplateField meta:resourcekey="TemplateFieldResource14">
                                        <ItemTemplate>
                                            <%# Eval("Description") %>&nbsp;-&nbsp;<%# Eval("Value").FormatDecimal(false) %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="# of..." 
                        meta:resourcekey="BoundFieldResource2">
                        <ItemTemplate>
                            <div><%# (Convert.ToInt32(Eval("NumberOfFlights")) > 0) ? String.Format(System.Globalization.CultureInfo.CurrentCulture, Resources.LocalizedText._8710NumberFlights, Eval("NumberOfFlights")) : string.Empty %></div>
                            <div><%# (Convert.ToInt32(Eval("AeroTows")) > 0) ? String.Format(System.Globalization.CultureInfo.CurrentCulture, Resources.LocalizedText.GliderAeroTows, Eval("AeroTows")) : string.Empty %></div>
                            <div><%# (Convert.ToInt32(Eval("WinchedLaunches")) > 0) ? String.Format(System.Globalization.CultureInfo.CurrentCulture, Resources.LocalizedText.GliderGroundLaunches, Eval("WinchedLaunches")) : string.Empty %></div>
                            <div><%# (Convert.ToInt32(Eval("SelfLaunches")) > 0) ? String.Format(System.Globalization.CultureInfo.CurrentCulture, Resources.LocalizedText.GliderSelfLaunches, Eval("SelfLaunches")) : string.Empty %></div>
                        </ItemTemplate>
                        <HeaderStyle CssClass="PaddedCell" />
                        <ItemStyle CssClass="PaddedCell" HorizontalAlign="Center" />
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <p><asp:Label ID="lblNoMatchingFlights" CssClass="error" runat="server" Text="<%$ Resources:LocalizedText, errNoMatchingFlightsFound %>" meta:resourcekey="lblNoMatchingFlightsResource1"></asp:Label></p>
                </EmptyDataTemplate>
            </asp:GridView>                    
            <p><asp:Localize ID="loc8710Notes" runat="server" Text="Notes:" 
                    meta:resourcekey="loc8710NotesResource1"></asp:Localize></p>
            <p><span class="FootNote">1</span><asp:Localize ID="loc8710Footnote1" 
                    runat="server" 
                    Text="To determine the amount of time where two fields are used, the minimum of the two fields is used.  For example, night PIC for a flight is the smaller of the amount of PIC or Night flying that is logged." 
                    meta:resourcekey="loc8710Footnote1Resource1"></asp:Localize></p>
            <p><span class="FootNote">2</span><asp:Localize ID="loc8710Footnote2" 
                    runat="server" 
                    Text="Instrument time comprises both actual and simulated instrument time." 
                    meta:resourcekey="loc8710Footnote2Resource1"></asp:Localize></p>
            <p><span class="FootNote">3</span><asp:Localize ID="loc8710Footnote3" 
                    runat="server" 
                    Text="If a flight has night-time take-offs/landings and PIC (SIC) time, then it is assumed that those landings are done while acting as PIC (SIC)." 
                    meta:resourcekey="loc8710Footnote3Resource1"></asp:Localize></p>
        </asp:View>
        <asp:View ID="vwQueryForm" runat="server">
            <uc2:mfbSearchForm ID="mfbSearchForm1" runat="server" OnQuerySubmitted="ShowResults" OnReset="ClearForm" InitialCollapseState="true" />
        </asp:View>
    </asp:MultiView>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cpMain" runat="Server">
    <uc6:mfbLogbook ID="MfbLogbook1" runat="server" />
</asp:Content>

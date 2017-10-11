<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" Trace="false"
    CodeFile="EditAircraft.aspx.cs" Inherits="EditMake" Title="" %>
<%@ Register Src="../Controls/mfbEditAircraft.ascx" TagName="mfbEditAircraft" TagPrefix="uc1" %>
<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Register src="../Controls/mfbATDFTD.ascx" tagname="mfbATDFTD" tagprefix="uc2" %>
<%@ Register src="../Controls/mfbLogbook.ascx" tagname="mfbLogbook" tagprefix="uc3" %>
<%@ Register src="../Controls/mfbTotalSummary.ascx" tagname="mfbTotalSummary" tagprefix="uc4" %>
<asp:Content ID="ContentHead" ContentPlaceHolderID="cpPageTitle" runat="server">
    <asp:Label ID="lblAddEdit1" runat="server" Text="Label"></asp:Label>
    <asp:Localize ID="locAircraftHeader" Text="<%$ Resources:Aircraft, AircraftHeader %>" runat="server"></asp:Localize> 
    <asp:Label ID="lblTail" runat="server" Text=""></asp:Label> <asp:Label ID="lblAdminMode" runat="server" Text=" - ADMIN MODE" Visible="false"></asp:Label>
</asp:Content>
<asp:Content ID="ContentTopForm" ContentPlaceHolderID="cpTopForm" runat="server">
    <script type="text/javascript" src='<%= ResolveUrl("~/public/daypilot-all.min.js") %>'></script>
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.10.1.min.js"></script>
    <script type="text/javascript" src='<%= ResolveUrl("~/public/jquery.json-2.4.min.js") %>'></script>
    <script type="text/javascript" src='<%= ResolveUrl("~/public/mfbcalendar.js") %>'></script>
    <div class="noprint">
        <uc2:mfbATDFTD ID="mfbATDFTD1" runat="server" />
        <p runat="server" id="reusetext" visible="false">
            <asp:Label ID="lblNote" Font-Bold="true" runat="server" Text="<%$ Resources:LocalizedText, Note %>"></asp:Label>&nbsp;
            <asp:Localize ID="locAircraftReuseWarning" runat="server" Text="<%$ Resources:LocalizedText, EditAircraftReuseAdvice %>"></asp:Localize>
        </p>
        <div style="float:left"><uc1:mfbEditAircraft id="MfbEditAircraft1" runat="server" OnAircraftUpdated="AircraftUpdated"></uc1:mfbEditAircraft></div>
    </div>
    <asp:HiddenField ID="hdnReturnURL" runat="server" />
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cpMain" runat="Server">
    <asp:Panel ID="pnlTotals" runat="server">
        <h2><asp:Label Font-Bold="true" ID="lblTail2" runat="server" Text=""></asp:Label></h2>
        <div style="float:left; clear:right; border: 1px solid black; padding: 3px; margin-right: 5px;" class="logbookForm">
            <asp:LinkButton ID="lnkShowFlights" runat="server" 
                onclick="lnkShowFlights_Click" Text="<%$ Resources:LocalizedText, EditAircraftViewMatchingFlights %>"></asp:LinkButton>
            <uc4:mfbTotalSummary ID="mfbTotalSummary1" runat="server" />
        </div>
    </asp:Panel>
    <uc3:mfbLogbook ID="mfbLogbook1" runat="server" Visible="false" DetailsPageUrlFormatString="~/Member/FlightDetail.aspx/{0}"
         EditPageUrlFormatString="~/Member/LogbookNew.aspx/{0}" AnalysisPageUrlFormatString="~/Member/FlightDetail.aspx/{0}?tabID=Chart" SendPageTarget="~/Member/LogbookNew.aspx" />
    <asp:HiddenField ID="hdnAdminMode" runat="server" />
    <asp:Panel ID="pnlAdminUserFlights" runat="server" Visible="false">
        <p>Clone an aircraft if the tailnumber can represent more than just this aircraft.  E.g., if N12345 used to be a piper cub and was re-assigned to a C-172, clone it to assign to the new aircraft.</p>
        <p>When cloning an aircraft:</p>
        <ul>
            <li>Select the NEW model above, then hit "Create new version".  The new version will be created using the specified model above.</li>
            <li>If you know that specific users belong in the newly created version, select them below PRIOR to cloning; they will be migrated automatically.</li>
        </ul>
        <asp:Button ID="btnMigrateGeneric" runat="server" 
            onclick="btnMigrateGeneric_Click" Text="Migrate to Generic" Visible="False" />
        <asp:Button ID="btnAdminCloneThis" runat="server" Text="Create New Version" CausesValidation="true" ValidationGroup="adminclone" 
            onclick="btnAdminCloneThis_Click" />
        <asp:Button ID="btnMakeDefault" runat="server" Text="MakeDefault" CausesValidation="true" Visible="false"
            onclick="btnAdminMakeDefault_Click" />
        <asp:CustomValidator ID="valModelSelected" runat="server" CssClass="error" 
            ErrorMessage="Please select a new (different) model to which to clone this aircraft" 
            onservervalidate="valModelSelected_ServerValidate" 
            ValidationGroup="adminclone" Display="Dynamic"></asp:CustomValidator>
            <asp:Label ID="lblErr" CssClass="error" runat="server" Text="" EnableViewState="false"></asp:Label>
        <asp:SqlDataSource ID="sqlDSFlightsPerUser" runat="server" 
            ConnectionString="<%$ ConnectionStrings:logbookConnectionString %>" 
            ProviderName="<%$ ConnectionStrings:logbookConnectionString.ProviderName %>" SelectCommand="SELECT u.email AS 'Email Address', u.username AS User, u.FirstName, u.LastName, count(f.idflight) AS 'Number of Flights'
FROM Useraircraft ua
   INNER JOIN users u ON ua.username=u.username
   LEFT JOIN flights f ON (f.username=ua.username AND f.idaircraft=?idaircraft)
WHERE ua.idaircraft=?idaircraft
GROUP BY ua.username">
        </asp:SqlDataSource>
        <asp:GridView ID="gvFlightsPerUser" runat="server" AutoGenerateColumns="False" 
            EnableModelValidation="True">
            <Columns>
                <asp:BoundField DataField="User" HeaderText="User" SortExpression="User" />
                <asp:BoundField DataField="Email Address" HeaderText="Email Address" 
                    SortExpression="Email Address" />
                <asp:BoundField DataField="FirstName" HeaderText="First Name" SortExpression="FirstName" />
                <asp:BoundField DataField="LastName" HeaderText="Last Name" SortExpression="LastName" />
                <asp:BoundField DataField="Number of Flights" HeaderText="Number of Flights" 
                    SortExpression="Number of Flights" />
                <asp:TemplateField HeaderText="Migrate to new aircraft?">
                    <ItemTemplate>
                        <asp:HiddenField ID="hdnUsername" Value='<%# Eval("User") %>' runat="server" />
                        <asp:CheckBox ID="ckMigrateUser" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </asp:Panel>
</asp:Content>
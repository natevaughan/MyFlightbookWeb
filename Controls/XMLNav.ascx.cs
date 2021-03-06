using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.UI;
using MyFlightbook;

/******************************************************
 * 
 * Copyright (c) 2007-2016 MyFlightbook LLC
 * Contact myflightbook-at-gmail.com for more information
 *
*******************************************************/

// This uses a CSS-styled menu bar based on http://www.cssportal.com/css3-menu-generator/.

public partial class XMLNav : System.Web.UI.UserControl
{
    /// <summary>
    /// Are the menus top-level only, or full popping hierarchy?
    /// </summary>
    public enum HoverStyle { Flat, HoverPop }

    #region Properties
    /// <summary>
    /// Which tab is selected?
    /// </summary>
    public tabID SelectedItem { get; set;}

    public string XmlSrc {get; set;}

    public HoverStyle MenuStyle { get; set; }

    private TabList m_tablist;
    public TabList TabList
    {
        get
        {
            if (m_tablist == null)
                m_tablist = new TabList(XmlSrc);
            return m_tablist;
        }
        set { m_tablist = value; }
    }

    public event EventHandler<TabBoundEventArgs> TabItemBound = null;
    #endregion

    private ProfileRoles.UserRole m_userRole;
    private HtmlTextWriter m_tw;

    void WriteTabs(IEnumerable<TabItem> lst)
    {
        foreach (TabItem ti in lst)
        {
            if (String.IsNullOrEmpty(ti.Text))
                continue;

            if (ti.Roles.Count> 0 && !ti.Roles.Contains(m_userRole))
                continue;

            bool fHideChildren = false;

            if (TabItemBound != null)
            {
                TabBoundEventArgs tbe = new TabBoundEventArgs(ti);
                TabItemBound(this, tbe);
                if (tbe.Cancel)
                    continue;
                fHideChildren = tbe.SuppressChildren;
            }

            if (ti.ID == SelectedItem)
                m_tw.AddAttribute(HtmlTextWriterAttribute.Class, "current");
            m_tw.RenderBeginTag(HtmlTextWriterTag.Li);

            m_tw.AddAttribute(HtmlTextWriterAttribute.Href, ResolveUrl(ti.Link));
            m_tw.AddAttribute(HtmlTextWriterAttribute.Id, "tabID" + ti.ID.ToString());
            m_tw.AddAttribute(HtmlTextWriterAttribute.Class, "topTab");
            m_tw.RenderBeginTag(HtmlTextWriterTag.A);
            m_tw.InnerWriter.Write(ti.Text);
            m_tw.RenderEndTag(); // Anchor tag

            if (this.MenuStyle == HoverStyle.HoverPop && ti.Children != null && ti.Children.Count() > 0 && !fHideChildren)
            {
                m_tw.RenderBeginTag(HtmlTextWriterTag.Ul);
                WriteTabs(ti.Children);
                m_tw.RenderEndTag();    // ul tag.
            }

            m_tw.RenderEndTag();    // li tag
        }
    }

    void Page_Load(Object sender, EventArgs e)
    {
        m_userRole = MyFlightbook.Profile.GetUser(Page.User.Identity.Name).Role;

        using (StringWriter sw = new StringWriter(System.Globalization.CultureInfo.CurrentCulture))
        {
            m_tw = new HtmlTextWriter(sw);
            WriteTabs(TabList.Tabs);
            LiteralControl lt = new LiteralControl(sw.ToString());
            plcMenuBar.Controls.Add(lt);
        }
    }
}

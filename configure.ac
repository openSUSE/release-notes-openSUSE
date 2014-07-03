dnl Process this file with autoconf to produce a configure script.
AC_INIT(release-notes-openSUSE, 13.2.1)
AC_SUBST(RN_DATE, 2014-07-02)
AM_INIT_AUTOMAKE

AC_SUBST(PACKAGE)
AC_SUBST(VERSION)

AC_PROG_CC

AC_CHECK_PROG(XSLTPROC, xsltproc, xsltproc)
AC_CHECK_PROG(XML2PO, xml2po, xml2po)
AC_CHECK_PROG(MSGMERGE, msgmerge, msgmerge)
AC_CHECK_PROG(MSGCAT, msgcat, msgcat)
AC_CHECK_PROG(MSGEN, msgen, msgen)

AC_PATH_PROG([FO2PDF], [fop])
AC_PATH_PROG([W3M], [w3m])
AC_PATH_PROG([DAPS], [daps])
AC_PATH_PROG([XMLLINT], [xmllint],[/bin/true])
AC_PATH_PROG(XMLCATALOG, xmlcatalog, no)
if test "x$XMLCATALOG" = xno; then
  echo no
fi

dnl XML_DTD="-//OASIS//DTD DocBook XML V4.5//EN"
for XML_DTD in "-//OASIS//DTD DocBook XML V4.5//EN" \
    http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl; do
  AC_MSG_CHECKING([for $XML_DTD])
  if AC_RUN_LOG([$XMLCATALOG --noout "/etc/xml/catalog" "$XML_DTD" >&2]); then
    AC_MSG_RESULT([found])
  else
    AC_MSG_ERROR([not found])
  fi
done

AM_CONDITIONAL(ENABLE_GENERATE_PDF, test ! -z "$FO2PDF")

AC_OUTPUT(Makefile xml/Makefile xml/release-notes.ent)

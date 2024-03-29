;;; apache-mode.el --- major mode for editing Apache configuration files

;; Copyright (c) 2004, 2005 Karl Chen <quarl@nospam.quarl.org>
;; Copyright (c) 1999 Jonathan Marten  <jonathan.marten@uk.sun.com>

;; Author: Karl Chen <quarl@nospam.quarl.org>

;; Keywords: languages, faces
;; Last edit: 2005-01-06
;; Version: 2.0 $Id: apache-mode.el 8264 2005-06-29 23:34:41Z quarl $

;; apache-mode.el is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2, or (at your option) any later
;; version.
;;
;; It is distributed in the hope that it will be useful, but WITHOUT ANY
;; WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.
;;
;; You should have received a copy of the GNU General Public License along
;; with your copy of Emacs; see the file COPYING.  If not, write to the Free
;; Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
;; 02111-1307, USA.

;;; Commentary:
;;
;;   (autoload 'apache-mode "apache-mode" nil t)
;;   (add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
;;   (add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
;;   (add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
;;   (add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
;;   (add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))
;;

;;; History:

;; 1999-10 Jonathan Marten <jonathan.marten@uk.sun.com>
;;   initial version

;; 2004-09-12 Karl Chen <quarl@nospam.quarl.org>
;;   rewrote pretty much everything using define-derived-mode; added support
;;   for Apache 2.x; fixed highlighting in GNU Emacs; created indentation
;;   function
;;
;; 2005-06-29 Kumar Appaiah <akumar_NOSPAM@ee.iitm.ac.in>
;;   use syntax table instead of font-lock-keywords to highlight comments.
;;
;; 2015-08-23 David Maus <dmaus@ictsoc.de>
;;   update list of directives for Apache 2.4

;;; Code:

;; Requires
(require 'regexp-opt)

(defvar apache-indent-level 4
  "*Number of spaces to indent per level")

(defvar apache-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?_   "_"    table)
    (modify-syntax-entry ?-   "_"    table)
    (modify-syntax-entry ?(   "()"   table)
    (modify-syntax-entry ?)   ")("   table)
    (modify-syntax-entry ?<   "(>"   table)
    (modify-syntax-entry ?>   ")<"   table)
    (modify-syntax-entry ?\"   "\""  table)
    (modify-syntax-entry ?,   "."    table)
    (modify-syntax-entry ?#   "<"    table)
    (modify-syntax-entry ?\n  ">#"   table)
    table))

;;;###autoload
(define-derived-mode apache-mode fundamental-mode "Apache"
  "Major mode for editing Apache configuration files."

  (set (make-local-variable 'comment-start) "# ")
  (set (make-local-variable 'comment-start-skip) "#\\W*")
  (set (make-local-variable 'comment-column) 48)

  (set (make-local-variable 'indent-line-function) 'apache-indent-line)

  (set (make-local-variable 'font-lock-defaults)
       '(apache-font-lock-keywords nil t
                                   ((?_ . "w")
                                    (?- . "w"))
                                   beginning-of-line)))

;; Font lock
(defconst apache-font-lock-keywords
  (purecopy
   (list

    ;; see syntax table for comment highlighting

    ;; (list "^[ \t]*#.*" 0 'font-lock-comment-face t)

    (list (concat                       ; sections
           "^[ \t]*</?"
           (regexp-opt '(

                         "AuthnProviderAlias"
                         "AuthzProviderAlias"
                         "Directory"
                         "DirectoryMatch"
                         "Else"
                         "ElseIf"
                         "Files"
                         "FilesMatch"
                         "If"
                         "IfDefine"
                         "IfDirective"
                         "IfFile"
                         "IfModule"
                         "IfSection"
                         "IfVersion"
                         "Limit"
                         "LimitExcept"
                         "Location"
                         "LocationMatch"
                         "Macro"
                         "MDomainSet"
                         "Proxy"
                         "ProxyMatch"
                         "RequireAll"
                         "RequireAny"
                         "RequireNone"
                         "VirtualHost"

                         ) 'words)
           ".*?>")
          1 'font-lock-function-name-face)

    (list (concat                       ; directives
           "^[ \t]*"
           (regexp-opt '
            (
             "AcceptFilter"
             "AcceptPathInfo"
             "AccessFileName"
             "Action"
             "AddAlt"
             "AddAltByEncoding"
             "AddAltByType"
             "AddCharset"
             "AddDefaultCharset"
             "AddDescription"
             "AddEncoding"
             "AddHandler"
             "AddIcon"
             "AddIconByEncoding"
             "AddIconByType"
             "AddInputFilter"
             "AddLanguage"
             "AddModuleInfo"
             "AddOutputFilter"
             "AddOutputFilterByType"
             "AddType"
             "Alias"
             "AliasMatch"
             "Allow"
             "AllowCONNECT"
             "AllowEncodedSlashes"
             "AllowMethods"
             "AllowOverride"
             "AllowOverrideList"
             "Anonymous"
             "Anonymous_LogEmail"
             "Anonymous_MustGiveEmail"
             "Anonymous_NoUserID"
             "Anonymous_VerifyEmail"
             "AsyncRequestWorkerFactor"
             "AuthBasicAuthoritative"
             "AuthBasicFake"
             "AuthBasicProvider"
             "AuthBasicUseDigestAlgorithm"
             "AuthDBDUserPWQuery"
             "AuthDBDUserRealmQuery"
             "AuthDBMGroupFile"
             "AuthDBMType"
             "AuthDBMUserFile"
             "AuthDigestAlgorithm"
             "AuthDigestDomain"
             "AuthDigestNonceLifetime"
             "AuthDigestProvider"
             "AuthDigestQop"
             "AuthDigestShmemSize"
             "AuthFormAuthoritative"
             "AuthFormBody"
             "AuthFormDisableNoStore"
             "AuthFormFakeBasicAuth"
             "AuthFormLocation"
             "AuthFormLoginRequiredLocation"
             "AuthFormLoginSuccessLocation"
             "AuthFormLogoutLocation"
             "AuthFormMethod"
             "AuthFormMimetype"
             "AuthFormPassword"
             "AuthFormProvider"
             "AuthFormSitePassphrase"
             "AuthFormSize"
             "AuthFormUsername"
             "AuthGroupFile"
             "AuthLDAPAuthorizePrefix"
             "AuthLDAPBindAuthoritative"
             "AuthLDAPBindDN"
             "AuthLDAPBindPassword"
             "AuthLDAPCharsetConfig"
             "AuthLDAPCompareAsUser"
             "AuthLDAPCompareDNOnServer"
             "AuthLDAPDereferenceAliases"
             "AuthLDAPGroupAttribute"
             "AuthLDAPGroupAttributeIsDN"
             "AuthLDAPInitialBindAsUser"
             "AuthLDAPInitialBindPattern"
             "AuthLDAPMaxSubGroupDepth"
             "AuthLDAPRemoteUserAttribute"
             "AuthLDAPRemoteUserIsDN"
             "AuthLDAPSearchAsUser"
             "AuthLDAPSubGroupAttribute"
             "AuthLDAPSubGroupClass"
             "AuthLDAPUrl"
             "AuthMerging"
             "AuthName"
             "AuthnCacheContext"
             "AuthnCacheEnable"
             "AuthnCacheProvideFor"
             "AuthnCacheSOCache"
             "AuthnCacheTimeout"
             "AuthnzFcgiCheckAuthnProvider"
             "AuthnzFcgiDefineProvider"
             "AuthType"
             "AuthUserFile"
             "AuthzDBDLoginToReferer"
             "AuthzDBDQuery"
             "AuthzDBDRedirectQuery"
             "AuthzDBMType"
             "AuthzSendForbiddenOnFailure"
             "BalancerGrowth"
             "BalancerInherit"
             "BalancerMember"
             "BalancerPersist"
             "BrowserMatch"
             "BrowserMatchNoCase"
             "BufferedLogs"
             "BufferSize"
             "CacheDefaultExpire"
             "CacheDetailHeader"
             "CacheDirLength"
             "CacheDirLevels"
             "CacheDisable"
             "CacheEnable"
             "CacheFile"
             "CacheHeader"
             "CacheIgnoreCacheControl"
             "CacheIgnoreHeaders"
             "CacheIgnoreNoLastMod"
             "CacheIgnoreQueryString"
             "CacheIgnoreURLSessionIdentifiers"
             "CacheKeyBaseURL"
             "CacheLastModifiedFactor"
             "CacheLock"
             "CacheLockMaxAge"
             "CacheLockPath"
             "CacheMaxExpire"
             "CacheMaxFileSize"
             "CacheMinExpire"
             "CacheMinFileSize"
             "CacheNegotiatedDocs"
             "CacheQuickHandler"
             "CacheReadSize"
             "CacheReadTime"
             "CacheRoot"
             "CacheSocache"
             "CacheSocacheMaxSize"
             "CacheSocacheMaxTime"
             "CacheSocacheMinTime"
             "CacheSocacheReadSize"
             "CacheSocacheReadTime"
             "CacheStaleOnError"
             "CacheStoreExpired"
             "CacheStoreNoStore"
             "CacheStorePrivate"
             "CGIDScriptTimeout"
             "CGIMapExtension"
             "CGIPassAuth"
             "CharsetDefault"
             "CharsetOptions"
             "CharsetSourceEnc"
             "CheckCaseOnly"
             "CheckSpelling"
             "ChrootDir"
             "ContentDigest"
             "CookieDomain"
             "CookieExpires"
             "CookieName"
             "CookieStyle"
             "CookieTracking"
             "CoreDumpDirectory"
             "CustomLog"
             "Dav"
             "DavDepthInfinity"
             "DavGenericLockDB"
             "DavLockDB"
             "DavMinTimeout"
             "DBDExptime"
             "DBDInitSQL"
             "DBDKeep"
             "DBDMax"
             "DBDMin"
             "DBDParams"
             "DBDPersist"
             "DBDPrepareSQL"
             "DBDriver"
             "DefaultIcon"
             "DefaultLanguage"
             "DefaultRuntimeDir"
             "DefaultType"
             "Define"
             "DeflateBufferSize"
             "DeflateCompressionLevel"
             "DeflateFilterNote"
             "DeflateInflateLimitRequestBody"
             "DeflateInflateRatioBurst"
             "DeflateInflateRatioLimit"
             "DeflateMemLevel"
             "DeflateWindowSize"
             "Deny"
             "DirectoryCheckHandler"
             "DirectoryIndex"
             "DirectoryIndexRedirect"
             "DirectorySlash"
             "DocumentRoot"
             "DTracePrivileges"
             "DumpIOInput"
             "DumpIOOutput"
             "EnableExceptionHook"
             "EnableMMAP"
             "EnableSendfile"
             "Error"
             "ErrorDocument"
             "ErrorLog"
             "ErrorLogFormat"
             "Example"
             "ExpiresActive"
             "ExpiresByType"
             "ExpiresDefault"
             "ExtendedStatus"
             "ExtFilterDefine"
             "ExtFilterOptions"
             "FallbackResource"
             "FileETag"
             "FilterChain"
             "FilterDeclare"
             "FilterProtocol"
             "FilterProvider"
             "FilterTrace"
             "ForceLanguagePriority"
             "ForceType"
             "ForensicLog"
             "GprofDir"
             "GracefulShutdownTimeout"
             "Group"
             "Header"
             "HeaderName"
             "HeartbeatAddress"
             "HeartbeatListen"
             "HeartbeatMaxServers"
             "HeartbeatStorage"
             "HeartbeatStorage"
             "HostnameLookups"
             "IdentityCheck"
             "IdentityCheckTimeout"
             "ImapBase"
             "ImapDefault"
             "ImapMenu"
             "Include"
             "IncludeOptional"
             "IndexHeadInsert"
             "IndexIgnore"
             "IndexIgnoreReset"
             "IndexOptions"
             "IndexOrderDefault"
             "IndexStyleSheet"
             "InputSed"
             "ISAPIAppendLogToErrors"
             "ISAPIAppendLogToQuery"
             "ISAPICacheFile"
             "ISAPIFakeAsync"
             "ISAPILogNotSupported"
             "ISAPIReadAheadBuffer"
             "KeepAlive"
             "KeepAliveTimeout"
             "KeptBodySize"
             "LanguagePriority"
             "LDAPCacheEntries"
             "LDAPCacheTTL"
             "LDAPConnectionPoolTTL"
             "LDAPConnectionTimeout"
             "LDAPLibraryDebug"
             "LDAPOpCacheEntries"
             "LDAPOpCacheTTL"
             "LDAPReferralHopLimit"
             "LDAPReferrals"
             "LDAPRetries"
             "LDAPRetryDelay"
             "LDAPSharedCacheFile"
             "LDAPSharedCacheSize"
             "LDAPTimeout"
             "LDAPTrustedClientCert"
             "LDAPTrustedGlobalCert"
             "LDAPTrustedMode"
             "LDAPVerifyServerCert"
             "LimitInternalRecursion"
             "LimitRequestBody"
             "LimitRequestFields"
             "LimitRequestFieldSize"
             "LimitRequestLine"
             "LimitXMLRequestBody"
             "Listen"
             "ListenBackLog"
             "LoadFile"
             "LoadModule"
             "LogFormat"
             "LogIOTrackTTFB"
             "LogLevel"
             "LogMessage"
             "LuaAuthzProvider"
             "LuaCodeCache"
             "LuaHookAccessChecker"
             "LuaHookAuthChecker"
             "LuaHookCheckUserID"
             "LuaHookFixups"
             "LuaHookInsertFilter"
             "LuaHookLog"
             "LuaHookMapToStorage"
             "LuaHookTranslateName"
             "LuaHookTypeChecker"
             "LuaInherit"
             "LuaInputFilter"
             "LuaMapHandler"
             "LuaOutputFilter"
             "LuaPackageCPath"
             "LuaPackagePath"
             "LuaQuickHandler"
             "LuaRoot"
             "LuaScope"
             "MaxConnectionsPerChild"
             "MaxKeepAliveRequests"
             "MaxMemFree"
             "MaxRangeOverlaps"
             "MaxRangeReversals"
             "MaxRanges"
             "MaxRequestWorkers"
             "MaxSpareServers"
             "MaxSpareThreads"
             "MaxThreads"
             "MergeTrailers"
             "MetaDir"
             "MetaFiles"
             "MetaSuffix"
             "MimeMagicFile"
             "MinSpareServers"
             "MinSpareThreads"
             "MMapFile"
             "ModemStandard"
             "ModMimeUsePathInfo"
             "MultiviewsMatch"
             "Mutex"
             "NameVirtualHost"
             "NoProxy"
             "NWSSLTrustedCerts"
             "NWSSLUpgradeable"
             "Options"
             "Order"
             "OutputSed"
             "PassEnv"
             "PidFile"
             "PrivilegesMode"
             "Protocol"
             "ProtocolEcho"
             "ProxyAddHeaders"
             "ProxyBadHeader"
             "ProxyBlock"
             "ProxyDomain"
             "ProxyErrorOverride"
             "ProxyExpressDBMFile"
             "ProxyExpressDBMType"
             "ProxyExpressEnable"
             "ProxyFtpDirCharset"
             "ProxyFtpEscapeWildcards"
             "ProxyFtpListOnWildcard"
             "ProxyHTMLBufSize"
             "ProxyHTMLCharsetOut"
             "ProxyHTMLDocType"
             "ProxyHTMLEnable"
             "ProxyHTMLEvents"
             "ProxyHTMLExtended"
             "ProxyHTMLFixups"
             "ProxyHTMLInterp"
             "ProxyHTMLLinks"
             "ProxyHTMLMeta"
             "ProxyHTMLStripComments"
             "ProxyHTMLURLMap"
             "ProxyIOBufferSize"
             "ProxyMaxForwards"
             "ProxyPass"
             "ProxyPassInherit"
             "ProxyPassInterpolateEnv"
             "ProxyPassMatch"
             "ProxyPassReverse"
             "ProxyPassReverseCookieDomain"
             "ProxyPassReverseCookiePath"
             "ProxyPreserveHost"
             "ProxyReceiveBufferSize"
             "ProxyRemote"
             "ProxyRemoteMatch"
             "ProxyRequests"
             "ProxySCGIInternalRedirect"
             "ProxySCGISendfile"
             "ProxySet"
             "ProxySourceAddress"
             "ProxyStatus"
             "ProxyTimeout"
             "ProxyVia"
             "ReadmeName"
             "ReceiveBufferSize"
             "Redirect"
             "RedirectMatch"
             "RedirectPermanent"
             "RedirectTemp"
             "ReflectorHeader"
             "RemoteIPHeader"
             "RemoteIPInternalProxy"
             "RemoteIPInternalProxyList"
             "RemoteIPProxiesHeader"
             "RemoteIPTrustedProxy"
             "RemoteIPTrustedProxyList"
             "RemoveCharset"
             "RemoveEncoding"
             "RemoveHandler"
             "RemoveInputFilter"
             "RemoveLanguage"
             "RemoveOutputFilter"
             "RemoveType"
             "RequestHeader"
             "RequestReadTimeout"
             "Require"
             "RewriteBase"
             "RewriteCond"
             "RewriteEngine"
             "RewriteMap"
             "RewriteOptions"
             "RewriteRule"
             "RLimitCPU"
             "RLimitMEM"
             "RLimitNPROC"
             "Satisfy"
             "ScoreBoardFile"
             "Script"
             "ScriptAlias"
             "ScriptAliasMatch"
             "ScriptInterpreterSource"
             "ScriptLog"
             "ScriptLogBuffer"
             "ScriptLogLength"
             "ScriptSock"
             "SecureListen"
             "SeeRequestTail"
             "SendBufferSize"
             "ServerAdmin"
             "ServerAlias"
             "ServerLimit"
             "ServerName"
             "ServerPath"
             "ServerRoot"
             "ServerSignature"
             "ServerTokens"
             "Session"
             "SessionCookieName"
             "SessionCookieName2"
             "SessionCookieRemove"
             "SessionCryptoCipher"
             "SessionCryptoDriver"
             "SessionCryptoPassphrase"
             "SessionCryptoPassphraseFile"
             "SessionDBDCookieName"
             "SessionDBDCookieName2"
             "SessionDBDCookieRemove"
             "SessionDBDDeleteLabel"
             "SessionDBDInsertLabel"
             "SessionDBDPerUser"
             "SessionDBDSelectLabel"
             "SessionDBDUpdateLabel"
             "SessionEnv"
             "SessionExclude"
             "SessionHeader"
             "SessionInclude"
             "SessionMaxAge"
             "SetEnv"
             "SetEnvIf"
             "SetEnvIfExpr"
             "SetEnvIfNoCase"
             "SetHandler"
             "SetInputFilter"
             "SetOutputFilter"
             "SSIEndTag"
             "SSIErrorMsg"
             "SSIETag"
             "SSILastModified"
             "SSILegacyExprParser"
             "SSIStartTag"
             "SSITimeFormat"
             "SSIUndefinedEcho"
             "SSLCACertificateFile"
             "SSLCACertificatePath"
             "SSLCADNRequestFile"
             "SSLCADNRequestPath"
             "SSLCARevocationCheck"
             "SSLCARevocationFile"
             "SSLCARevocationPath"
             "SSLCertificateChainFile"
             "SSLCertificateFile"
             "SSLCertificateKeyFile"
             "SSLCipherSuite"
             "SSLCompression"
             "SSLCryptoDevice"
             "SSLEngine"
             "SSLFIPS"
             "SSLHonorCipherOrder"
             "SSLInsecureRenegotiation"
             "SSLOCSPDefaultResponder"
             "SSLOCSPEnable"
             "SSLOCSPOverrideResponder"
             "SSLOCSPResponderTimeout"
             "SSLOCSPResponseMaxAge"
             "SSLOCSPResponseTimeSkew"
             "SSLOCSPUseRequestNonce"
             "SSLOpenSSLConfCmd"
             "SSLOptions"
             "SSLPassPhraseDialog"
             "SSLProtocol"
             "SSLProxyCACertificateFile"
             "SSLProxyCACertificatePath"
             "SSLProxyCARevocationCheck"
             "SSLProxyCARevocationFile"
             "SSLProxyCARevocationPath"
             "SSLProxyCheckPeerCN"
             "SSLProxyCheckPeerExpire"
             "SSLProxyCheckPeerName"
             "SSLProxyCipherSuite"
             "SSLProxyEngine"
             "SSLProxyMachineCertificateChainFile"
             "SSLProxyMachineCertificateFile"
             "SSLProxyMachineCertificatePath"
             "SSLProxyProtocol"
             "SSLProxyVerify"
             "SSLProxyVerifyDepth"
             "SSLRandomSeed"
             "SSLRenegBufferSize"
             "SSLRequire"
             "SSLRequireSSL"
             "SSLSessionCache"
             "SSLSessionCacheTimeout"
             "SSLSessionTicketKeyFile"
             "SSLSessionTickets"
             "SSLSRPUnknownUserSeed"
             "SSLSRPVerifierFile"
             "SSLStaplingCache"
             "SSLStaplingErrorCacheTimeout"
             "SSLStaplingFakeTryLater"
             "SSLStaplingForceURL"
             "SSLStaplingResponderTimeout"
             "SSLStaplingResponseMaxAge"
             "SSLStaplingResponseTimeSkew"
             "SSLStaplingReturnResponderErrors"
             "SSLStaplingStandardCacheTimeout"
             "SSLStrictSNIVHostCheck"
             "SSLUserName"
             "SSLUseStapling"
             "SSLVerifyClient"
             "SSLVerifyDepth"
             "StartServers"
             "StartThreads"
             "Substitute"
             "SubstituteMaxLineLength"
             "Suexec"
             "SuexecUserGroup"
             "ThreadLimit"
             "ThreadsPerChild"
             "ThreadStackSize"
             "TimeOut"
             "TraceEnable"
             "TransferLog"
             "TypesConfig"
             "UnDefine"
             "UndefMacro"
             "UnsetEnv"
             "Use"
             "UseCanonicalName"
             "UseCanonicalPhysicalPort"
             "User"
             "UserDir"
             "VHostCGIMode"
             "VHostCGIPrivs"
             "VHostGroup"
             "VHostPrivs"
             "VHostSecure"
             "VHostUser"
             "VirtualDocumentRoot"
             "VirtualDocumentRootIP"
             "VirtualScriptAlias"
             "VirtualScriptAliasIP"
             "WatchdogInterval"
             "XBitHack"
             "xml2EncAlias"
             "xml2EncDefault"
             "xml2StartParse"
             )
            'words))
          1 'font-lock-keyword-face)

    (list                               ; values
     (regexp-opt '
      (
       "All"
       "AuthConfig"
       "Basic"
       "CONNECT"
       "DELETE"
       "Digest"
       "ExecCGI"
       "FancyIndexing"
       "FileInfo"
       "FollowSymLinks"
       "Full"
       "GET"
       "IconsAreLinks"
       "Includes"
       "IncludesNOEXEC"
       "Indexes"
       "Limit"
       "Minimal"
       "MultiViews"
       "None"
       "OPTIONS"
       "OS"
       "Options"
       "Options"
       "POST"
       "PUT"
       "ScanHTMLTitles"
       "SuppressDescription"
       "SuppressLastModified"
       "SuppressSize"
       "SymLinksIfOwnerMatch"
       "URL"
       "add"
       "allow"
       "any"
       "append"
       "deny"
       "double"
       "downgrade-1.0"
       "email"
       "env"
       "error"
       "force-response-1.0"
       "formatted"
       "from"
       "full"
       "gone"
       "group"
       "inetd"
       "inherit"
       "map"
       "mutual-failure"
       "nocontent"
       "nokeepalive"
       "none"
       "off"
       "on"
       "permanent"
       "referer"
       "seeother"
       "semi-formatted"
       "set"
       "standalone"
       "temporary"
       "unformatted"
       "unset"
       "user"
       "valid-user"
       ) 'words)
     1 'font-lock-type-face)))
  "Expressions to highlight in Apache config buffers.")

(defun apache-indent-line ()
   "Indent current line of Apache code."
   (interactive)
   (let ((savep (> (current-column) (current-indentation)))
	 (indent (max (apache-calculate-indentation) 0)))
     (if savep
	 (save-excursion (indent-line-to indent))
       (indent-line-to indent))))


(defun apache-previous-indentation ()
  ;; Return the previous (non-empty/comment) indentation.  Doesn't save
  ;; position.
  (let (indent)
    (while (and (null indent)
                (zerop (forward-line -1)))
      (unless (looking-at "[ \t]*\\(#\\|$\\)")
        (setq indent (current-indentation))))
    (or indent 0)))

(defun apache-calculate-indentation ()
  ;; Return the amount the current line should be indented.
  (save-excursion
    (forward-line 0)
    (if (bobp)
        0
      (let ((ends-section-p (looking-at "[ \t]*</"))
            (indent (apache-previous-indentation)) ; moves point!
            (previous-starts-section-p (looking-at "[ \t]*<[^/]")))
        (if ends-section-p
            (setq indent (- indent apache-indent-level)))
        (if previous-starts-section-p
            (setq indent (+ indent apache-indent-level)))
        indent))))

;;;###autoload(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
;;;###autoload(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
;;;###autoload(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
;;;###autoload(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
;;;###autoload(add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))

(provide 'apache-mode)

;;; apache-mode.el ends here

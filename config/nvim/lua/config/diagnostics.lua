vim.api.nvim_exec([[
    highlight LspReferenceRead gui=underline
    highlight LspReferenceText gui=underline
    highlight LspReferenceWrite gui=underline
    highlight LspDiagnosticsSignError guifg=#f43753
    highlight LspDiagnosticsSignWarning guifg=#79313c
    highlight LspDiagnosticsSignInformation guifg=#ffc24b
    highlight LspDiagnosticsSignHint guifg=#9faa00
    highlight LspDiagnosticsSignError guifg=#f43753
    highlight LspDiagnosticsSignWarning guifg=#79313c
    highlight LspDiagnosticsSignInformation guifg=#ffc24b
    highlight LspDiagnosticsSignHint guifg=#9faa00
    highlight LspDiagnosticsVirtualTextError guifg=#f43753
    highlight LspDiagnosticsVirtualTextWarning guifg=#79313c
    highlight LspDiagnosticsVirtualTextInformation guifg=#ffc24b
    highlight LspDiagnosticsVirtualTextHint guifg=#9faa00
    highlight LspDiagnosticsUnderlineError guifg=#f43753
    highlight LspDiagnosticsUnderlineError gui=underline,bold
    highlight LspDiagnosticsUnderlineWarning guifg=#79313c
    highlight LspDiagnosticsUnderlineInformation guifg=#ffc24b
    highlight LspDiagnosticsUnderlineHint guifg=#9faa00
    highlight LspDiagnosticsFloatingError guifg=#dadada
    highlight LspDiagnosticsFloatingWarning guifg=#79313c
    highlight LspDiagnosticsFloatingInformation guifg=#ffc24b
    highlight LspDiagnosticsFloatingHint guifg=#9faa00
  ]], false)


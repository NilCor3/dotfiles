-- Java LSP via nvim-jdtls.
-- jdtls server and debug adapter installed by ~/.local/share/chezmoi/run_once_setup-java-lsp.sh
-- Java runtime discovered via `mise where java`.

local base = vim.fn.expand('~/.local/share/nvim-java')
local launcher = vim.fn.glob(base .. '/jdtls/plugins/org.eclipse.equinox.launcher_*.jar')
local os_config = base .. '/jdtls/config_mac'
local lombok = base .. '/lombok.jar'
local java_debug_jar = base .. '/java-debug.jar'

if launcher == '' then
  vim.notify('jdtls not found. Run: chezmoi apply (needs run_once_setup-java-lsp.sh)', vim.log.levels.WARN)
  return
end

local java_home = vim.trim(vim.fn.system('mise where java 2>/dev/null'))
local java_bin = java_home ~= '' and java_home .. '/bin/java' or 'java'

local home = os.getenv('HOME')
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/code/workspace/' .. project_name

local root_dir = vim.fs.dirname(
  vim.fs.find({ 'pom.xml', 'gradlew', 'build.gradle', '.git', 'mvnw' }, { upward = true })[1]
)

local capabilities = {
  workspace = { configuration = true },
  textDocument = { completion = { snippetSupport = false } },
}
local blink_caps = require('blink.cmp').get_lsp_capabilities()
for k, v in pairs(blink_caps) do
  capabilities[k] = v
end

local extendedClientCapabilities = require('jdtls').extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local bundles = {}
if vim.fn.filereadable(java_debug_jar) == 1 then
  table.insert(bundles, java_debug_jar)
end

local cmd = {
  java_bin,
  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  '-Dosgi.bundles.defaultStartLevel=4',
  '-Declipse.product=org.eclipse.jdt.ls.core.product',
  '-Dlog.protocol=true',
  '-Dlog.level=ALL',
  '-Xmx1g',
  '--add-modules=ALL-SYSTEM',
  '--add-opens', 'java.base/java.util=ALL-UNNAMED',
  '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
  '-javaagent:' .. lombok,
  '-jar', launcher,
  '-configuration', os_config,
  '-data', workspace_dir,
}

local settings = {
  java = {
    format = {
      enabled = true,
      settings = {
        url = vim.fn.stdpath('config') .. '/formatters/java-style.xml',
        profile = 'fortnoxStyle',
      },
    },
    eclipse = { downloadSource = true },
    maven = { downloadSources = true },
    signatureHelp = { enabled = true },
    contentProvider = { preferred = 'fernflower' },
    saveActions = { organizeImports = false },
    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
      filteredTypes = {
        'com.sun.*', 'io.micrometer.shaded.*', 'java.awt.*', 'jdk.*', 'sun.*',
      },
      importOrder = { 'java', 'jakarta', 'javax', 'com', 'org' },
    },
    sources = {
      organizeImports = { starThreshold = 9999, staticThreshold = 9999 },
    },
    codeGeneration = {
      toString = { template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}' },
      hashCodeEquals = { useJava7Objects = true },
      useBlocks = true,
    },
    configuration = { updateBuildConfiguration = 'interactive' },
    referencesCodeLens = { enabled = true },
    inlayHints = { parameterNames = { enabled = 'all' } },
  },
}

local on_attach = function(_, bufnr)
  -- Java-specific commands
  vim.cmd("command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)")
  vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
  vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
  vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

  vim.keymap.set('n', '<leader>Jo', "<Cmd>lua require('jdtls').organize_imports()<CR>", { buffer = bufnr, desc = 'Java: Organize Imports' })
  vim.keymap.set('n', '<leader>Jv', "<Cmd>lua require('jdtls').extract_variable()<CR>", { buffer = bufnr, desc = 'Java: Extract Variable' })
  vim.keymap.set('v', '<leader>Jv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { buffer = bufnr, desc = 'Java: Extract Variable' })
  vim.keymap.set('n', '<leader>JC', "<Cmd>lua require('jdtls').extract_constant()<CR>", { buffer = bufnr, desc = 'Java: Extract Constant' })
  vim.keymap.set('v', '<leader>JC', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", { buffer = bufnr, desc = 'Java: Extract Constant' })
  vim.keymap.set('n', '<leader>Ju', '<Cmd>JdtUpdateConfig<CR>', { buffer = bufnr, desc = 'Java: Update Config' })

  if #bundles > 0 then
    require('jdtls.dap').setup_dap()
    require('jdtls.dap').setup_dap_main_class_configs()
  end
  require('jdtls.setup').add_commands()
  vim.lsp.codelens.refresh()

  require('lsp_signature').on_attach({
    bind = true,
    padding = '',
    handler_opts = { border = 'rounded' },
    hint_prefix = '󱄑 ',
  }, bufnr)

  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.java' },
    callback = function()
      pcall(vim.lsp.codelens.refresh)
    end,
  })
end

require('jdtls').start_or_attach({
  cmd = cmd,
  root_dir = root_dir,
  settings = settings,
  capabilities = capabilities,
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
  on_attach = on_attach,
})


local fennel = require('fennel')

-- table.insert(
--   package.loaders,
--   fennel.make_searcher {
--     correlate=true,
--     useMetadata=true,
--     moduleName="fennel"
--   }
-- )

table.insert(package.loaders or package.searchers, fennel.searcher)

require('application')

local test_rb = require("test_ragebait_controller")

local ok, err = pcall(test_rb.run)
if not ok then
    print("Tests failed: ", err)
    os.exit(1)
end
os.exit(0)
local module = {}

function module.MergeObject(target, source)
	if type(target) ~= "table" then
		target = {}
	end

	for key, value in pairs(source) do
		if type(value) == "table" and type(target[key]) == "table" then
			module.MergeObject(target[key], value)
		else
			target[key] = value
		end
	end

	return target
end

return module

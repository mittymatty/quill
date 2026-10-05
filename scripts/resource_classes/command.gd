class_name Command extends Resource
@export var called_function: String
@export var parameters: Array

func action () -> void:
	Callable(Commands,called_function).call(parameters)

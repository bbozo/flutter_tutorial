import 'package:scoped_model/scoped_model.dart';

class RegisteredModel extends Model {
  ModelRegistry modelRegistry;
  RegisteredModel(this.modelRegistry);
}

class ModelRegistry {
  Map<String, Model> _registry = {};

  void register(String id, Model modelInstance) {
    if(_registry.containsKey(id))
      throw new ArgumentError("Model " + id + " already registered");
    _registry[id] = modelInstance;
  }

  Model operator[](String id) => _registry[id];

}

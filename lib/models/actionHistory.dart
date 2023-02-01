class ActionHistory {
  static List<ActionItem> _actions = [];
  static const int _maxItems = 20;

  static void addNewRawAction(int actionState, String action) {
    _actions.add(ActionItem(actionState, action));

    if (_actions.length > _maxItems) _actions.removeAt(0);
  }

  static void addNewAction(ActionItem action) {
    _actions.add(action);

    if (_actions.length > _maxItems) _actions.removeAt(0);
  }

  static int getLength() {
    return _actions.length;
  }

  static ActionItem getActionFromIndex(int index) {
    if (index < _actions.length) return _actions[index];
    return null;
  }

  static List<ActionItem> getActions() {
    return List<ActionItem>.generate(_actions.length, (index) {
      return _actions[index];
    });
  }

  static Map toJson() => {
        "_actions": _actions.map((ActionItem item) {
          return item.toJson();
        }).toList(),
      };

  static List<ActionItem> fromJson(List json) {
    return List<ActionItem>.generate(json.length, (index) {
      return ActionItem(json[index]["_actionState"], json[index]["_action"]);
    });
  }
}

class ActionItem {
  final int _actionState;
  final String _action;

  ActionItem(this._actionState, this._action);

  int getActionState() {
    return _actionState;
  }

  String getAction() {
    return _action;
  }

  Map toJson() => {
        "_actionState": _actionState,
        "_action": _action,
      };

  static ActionItem fromJson(Map json) {
    return ActionItem(json["_actionState"], json["_action"]);
  }
}

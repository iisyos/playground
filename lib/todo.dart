import 'package:flutter/foundation.dart' show immutable;
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

@immutable
class Todo {
  const Todo({
    required this.description,
    required this.id,
    this.completed = false,
  });

  final String id;
  final String description;
  final bool completed;

  @override
  String toString(){
    return 'Todo(description: $description, completed: $completed)';
  }
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList(List<Todo>? initialTodos) : super(initialTodos??[]);

  void add (String description){
    state=[
      ...state,
      Todo(
        id:_uuid.v4(),
        description: description,
      )
    ];
  }

  void toggle(String id){
    state=[
      for(Todo todo in state)
        if(id == todo.id)
          Todo(
            id: todo.id,
            description: todo.description,
            completed: !todo.completed
          )
      else todo
    ];
  }

  void edit({required String id,required String description}){
    state = [
    for(Todo todo in state)
      if(id == todo.id)
        Todo(
          id: todo.id,
          description: description,
          completed: todo.completed
        )
    else
      todo
    ];
  }

  void remove (String id){
    state = state.where((element) => element.id != id).toList();
  }
}
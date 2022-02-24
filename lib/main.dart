import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'todo.dart';

final addTodoKey = UniqueKey();
final activeFilterKey = UniqueKey();
final completedFilterKey = UniqueKey();
final allFilterKey = UniqueKey();

final todoListProvider = StateNotifierProvider<TodoList,List<Todo> >((ref) {
  return TodoList(
    const [Todo(id: "test1",description: "test1")]
  );
});

enum TodoListFilter {
  all,
  active,
  completed
}

final todoListFilter = StateProvider<TodoListFilter>((ref) { return TodoListFilter.all;});

final uncompletedTodosCount = Provider<int>((ref) {
  return ref.watch(todoListProvider).where((element) => !element.completed).length;
});

final filteredTodos = StateProvider<List<Todo>>((ref) {
  final filter=ref.watch(todoListFilter);
  final todoList=ref.watch(todoListProvider);
  switch (filter){
    case TodoListFilter.active:
      return todoList.where((element) => !element.completed).toList();
    case TodoListFilter.completed:
      return todoList.where((element) => element.completed).toList();
    case TodoListFilter.all:
      return todoList;
  }
});


void main() {
  runApp(
  const ProviderScope(
    child: MyApp()
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends HookConsumerWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos =ref.watch(filteredTodos);
    final newTodoController = useTextEditingController();
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          children: [
            TextField(
              key: addTodoKey,
              controller: newTodoController,
              decoration: const InputDecoration(
                labelText:"What needs to be done"
              ),
              onSubmitted: (value){
                ref.read(todoListProvider.notifier).add(value);
                newTodoController.clear();
              },
            ),
            const SizedBox(height: 42),
            Toolbar(),
            if(todos.isEmpty) const Divider(height: 0),
            for(var i =0; i < todos.length;i++ )...[
              if(i>0) const Divider(height: 0),
              ProviderScope(
                overrides: [_currentTodo.overrideWithValue(todos[i])],
                child: const TodoItem2(),
              )

            ]
          ],
        ),
      ),
    );
  }
}

final _currentTodo = Provider<Todo>((ref) {
  return throw UnimplementedError();
});

// final _currentTodo = Provider<Todo>((ref) => throw UnimplementedError());


class TodoItem2 extends HookConsumerWidget {
  const TodoItem2({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(_currentTodo);
    final itemFocusNode = useFocusNode();
    useListenable(itemFocusNode);
    final isFocused = itemFocusNode.hasFocus;

    final textEditingController = useTextEditingController();
    final textEditingFocusNode = useFocusNode();

    // final Focused = FocusNode();
    // final isFocused =Focused.hasFocus;
    return Material(
      child: Focus(
        focusNode: itemFocusNode,
        onFocusChange: (focused){
          if(focused){
            textEditingController.text=todo.description;

          }else{
            ref.read(todoListProvider.notifier).
            edit(id: todo.id, description: textEditingController.text);
          }
        },
        child:ListTile(onTap:(){
          print("tapped");
          itemFocusNode.requestFocus();
          textEditingFocusNode.requestFocus();
        },
          leading: Checkbox(
            value: todo.completed,
          onChanged:(value){
              ref.read(todoListProvider.notifier).toggle(todo.id);
          },),
          title: isFocused?
          TextField(
            focusNode: textEditingFocusNode,
            autofocus: true,
            controller: textEditingController,
          ):Text(todo.description),
        ),
      ),
    );
  }
}

class TodoItem extends HookConsumerWidget {
  const TodoItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(_currentTodo);
    final itemFocusNode = useFocusNode();
    // listen to focus chances
    useListenable(itemFocusNode);
    final isFocused = itemFocusNode.hasFocus;

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();

    return Material(
      child: Focus(
        focusNode: itemFocusNode,
        onFocusChange: (focused){
          if(focused){
            textEditingController.text = todo.description;
          }else{
            ref.read(todoListProvider.notifier).edit(id: todo.id, description: textEditingController.text);
          }
        },
        child: ListTile(
          onTap:(){
            itemFocusNode.requestFocus();
            textFieldFocusNode.requestFocus();
          },
          leading: Checkbox(
            value: todo.completed,
            onChanged: (value)=> ref.read(todoListProvider.notifier).toggle(todo.id),
          ),
            title: isFocused
            ?TextField(
          autofocus: true,
          focusNode: textFieldFocusNode,
          controller: textEditingController,
        ):Text(todo.description)

        ),
      ),
    );
  }
}


class Toolbar extends ConsumerWidget {
  const Toolbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoListFilter);

    Color? textColorFor(TodoListFilter value) {
      return filter == value ? Colors.blue : Colors.black;
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${ref.watch(uncompletedTodosCount).toString()} items left',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tooltip(
            key: allFilterKey,
            message: 'All todos',
            child: TextButton(
              onPressed: (){
              ref.read(todoListFilter.notifier).state = TodoListFilter.all;
              print('${ref.watch(_currentTodo)}');
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor:
                MaterialStateProperty.all(textColorFor(TodoListFilter.all)),
              ),
              child: const Text('All'),
            ),
          ),
          Tooltip(
            key: activeFilterKey,
            message: 'Only uncompleted todos',
            child: TextButton(
              onPressed: () => ref.read(todoListFilter.notifier).state =
                  TodoListFilter.active,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: MaterialStateProperty.all(
                  textColorFor(TodoListFilter.active),
                ),
              ),
              child: const Text('Active'),
            ),
          ),
          Tooltip(
            key: completedFilterKey,
            message: 'Only completed todos',
            child: TextButton(
              onPressed: () => ref.read(todoListFilter.notifier).state =
                  TodoListFilter.completed,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: MaterialStateProperty.all(
                  textColorFor(TodoListFilter.completed),
                ),
              ),
              child: const Text('Completed'),
            ),
          ),
        ],
      ),
    );
  }
}

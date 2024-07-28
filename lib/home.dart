import 'package:flutter/material.dart';
import 'todo.dart';
import 'color.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<ToDo> todos = [
    ToDo(id: '1', title: 'Check mail'),
    ToDo(id: '2', title: 'Buy groceries'),
    ToDo(id: '3', title: 'Walk the dog'),
    ToDo(id: '03', title: 'Check Emails', ),
    ToDo(id: '04', title: 'Team Meeting', ),
    ToDo(id: '05', title: 'Work on mobile apps for 2 hour', ),
    ToDo(id: '06', title: 'Dinner with Jenny', ),
  ];

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _handleDeleteItem(ToDo todo) {
    setState(() {
      todos.remove(todo);
    });
  }

  void _showEditDialog(ToDo? todo) {
    final TextEditingController controller = TextEditingController(
      text: todo?.title ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(todo == null ? 'Add Note' : 'Edit Note'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter note title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (todo == null) {
                  setState(() {
                    todos.add(ToDo(
                      id: DateTime.now().toString(),
                      title: controller.text,
                    ));
                  });
                } else {
                  setState(() {
                    todo.title = controller.text;
                  });
                }
                Navigator.pop(context);
              },
              child: Text(todo == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        backgroundColor: tdBGColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.menu,
              color: tdBlack,
              size: 30,
            ),
            Container(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('asssets/1.jpeg'), // Corrected 'asssets' to 'assets'
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9, // Adjust the width as needed
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: tdBlack,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(color: tdGrey),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                'All To Dos',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return ToDoItem(
                    todo: todos[index],
                    onToDoChanged: _handleToDoChange,
                    onDeleteItem: _handleDeleteItem,
                    onEditItem: () => _showEditDialog(todos[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(null),
        child: Icon(Icons.add),
        backgroundColor: tdBlue,
      ),
    );
  }
}

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) onToDoChanged;
  final Function(ToDo) onDeleteItem;
  final VoidCallback onEditItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
    required this.onEditItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 16,
            color: tdBlack,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: tdBlack,
              onPressed: onEditItem,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: tdRed,
              onPressed: () {
                onDeleteItem(todo);
                print('Clicked on delete is done');
              },
            ),
          ],
        ),
      ),
    );
  }
}

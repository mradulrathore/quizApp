import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz_app/model/content.dart';
import 'package:http/http.dart' as http;

class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  Content result;
  List<Results> questionsData;
  Future<List<Results>> question;
  var unescape = HtmlUnescape();
  
  @override
  void initState() {
    super.initState();
    question = fetchQuestions();
  }

  Future<List<Results>> fetchQuestions() async {
    var url = 'https://opentdb.com/api.php?amount=20';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var resultsJson = jsonDecode(response.body);
      result = Content.fromJson(resultsJson);
      questionsData = result.results;
      return questionsData;
    } else {
      throw Exception('Failed to Load');
    }
  }

  Widget chip(int index) {
    return Wrap(
      spacing: 5.0,
      runSpacing: 1.0,
      children: <Widget>[
        Chip(
          // labelPadding: EdgeInsets.all(5.0),
          label: Text(
            questionsData[index].category,
            style: TextStyle(
              color: Color(0xff6200ee),
              fontSize: 12.0,
            ),
          ),
          backgroundColor: Color(0xffededed),
          elevation: 2.0,
          padding: EdgeInsets.all(6.0),
        ),
        Chip(
          // labelPadding: EdgeInsets.all(5.0),
          label: Text(
            questionsData[index].difficulty,
            style: TextStyle(
              color: Color(0xff6200ee),
              fontSize: 12.0,
            ),
          ),
          backgroundColor: Color(0xffededed),
          elevation: 2.0,
          padding: EdgeInsets.all(6.0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz App',
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 31.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                 
                  question = fetchQuestions();
                });
              },
              child: Icon(
                Icons.refresh,
              ),
            ),
          ),
        ],
        elevation: 0.0,
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.green,
        onRefresh: () {
          setState(() {
            question = fetchQuestions();
          });
          return question;
        },
        child: FutureBuilder(
          future: question,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: questionsData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ExpansionTile(
                          title: Text(
                            unescape.convert(questionsData[index].question),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: chip(index),
                          /*
                          leading: CircleAvatar(
                            child: Text(
                                questionsData[index].category.substring(0, 1)),
                          ),
                          */
                          children:
                              questionsData[index].allAnswers.map((options) {
                            return Options(index, questionsData, options);
                          }).toList(),
                          onExpansionChanged: (_) {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            else
              return 
                 LinearProgressIndicator();
          },
        ),
      ),
    );
  }
}

class Options extends StatefulWidget {
  final int index;
  final List<Results> questionsData;
  final String selected;

  Options(this.index, this.questionsData, this.selected);
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  Color col = Colors.black;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          col = widget.selected ==
                  widget.questionsData[widget.index].correctAnswer
              ? Colors.green
              : Colors.red;
        });
      },
      title: Text(widget.selected,
          style: TextStyle(
            color: col,
          )),
    );
  }
}

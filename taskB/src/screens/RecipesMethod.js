//Shows all recipe methods of specific category/recipe.
//Pass all comments of this recipe.
import React, { useState, useEffect } from 'react';
import { SafeAreaView, FlatList, TouchableOpacity, View, Text, TextInput, StyleSheet } from 'react-native';
import { jsonData } from "../json/ReceipJson";
import AsyncStorage from '@react-native-community/async-storage'

const STORAGE_KEY = '@comment'

function RecipesMethodScreen({ route, navigation }) {
  // When loading page, call readData()
  useEffect(() => {
    readData();
  }, []);

  const [commentText, setCommentText] = useState("");
  const [commentList, setCommentList] = useState([]);
  // receive id, categoryName and recipeName from before page(recipes)
  const { id, categoryName, recipeName } = route.params;

  const DATA = jsonData.recipesList
  // Filter data with before recipeId
  const filterData = DATA.filter(element => element.id == id);
  // Making unique id for saving comments
  function makeUniqueId() {
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for (var i = 0; i < 5; i++)
      text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
  }
  // Delete comment for specific id
  const deleteComment = (id) => {
    const newCommentList = commentList.filter(item => item.id !== id);
    setCommentList(newCommentList);
    saveData(newCommentList);
  }

  // Store dataArray in AsyncStorage
  let tempComment = {}
  const saveData = async (dataArray) => {
    try {
      await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(dataArray))
    } catch (e) {
      alert('Failed to save the data to the storage')
    }
  }

  // Read totalCommentList from AsyncStorage
  const readData = async () => {
    try {
      const totalCommentList = await AsyncStorage.getItem(STORAGE_KEY)
      if (totalCommentList !== null) {
        const storageCommentList = JSON.parse(totalCommentList);
        setCommentList(storageCommentList)
      }
    } catch (e) {
      alert('Failed to fetch the data from storage')
    }
  }

  const renderItem = ({ item }) => (
    <Item recipeName={item.recipeName} recipeContent={item.recipeContent}
      navigation={navigation} />
  );

  const Item = ({ recipeContent }) => (
    <View style={styles.item}>
      <Text style={styles.recipeName}>{recipeContent}</Text>
    </View>
  );

  const commentItem = ({ item }) => (
    <View style={styles.commentDiv}>
      <Text>{item.comment}</Text>
      <TouchableOpacity onPress={() => deleteComment(item.id)}>
        <Text>X</Text>
      </TouchableOpacity>
    </View>
  )
  // Leave comment when CommentLeave button clicked.
  const leaveComment = () => {
    tempComment = { recipeId: id, comment: commentText, id: makeUniqueId() }
    const newDataArray = [...commentList, tempComment];
    if (commentText !== "") {
      saveData(newDataArray)
      readData();
      setCommentText("");
    }
    else {
      alert("Please fill the input");
    }
  }

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.topText}>{categoryName}/{recipeName}</Text>
      <FlatList
        data={filterData}
        renderItem={renderItem}
        keyExtractor={item => item.id.toString()}
      />
      {commentList.length !== 0 && <FlatList
        data={commentList.filter(item => item.recipeId === id)}
        renderItem={commentItem}
        keyExtractor={item => item.id.toString()}
      />}

      <View style={styles.panel}>
        <View style={styles.buttonDiv}>
          <TouchableOpacity style={styles.button} onPress={() => leaveComment()}>
            <Text style={styles.buttonText}>Comment Leave</Text>
          </TouchableOpacity>
        </View>
        <TextInput
          style={styles.input}
          onChangeText={(username) => setCommentText(username)}
          value={commentText}
          multiline
          placeholder="Please leave your comment here..."
        />
      </View>
    </SafeAreaView>
  );
}

export default RecipesMethodScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  item: {
    padding: 10,
    marginVertical: 8,
    marginHorizontal: 8,
    borderTopColor: "gray",
    borderLeftColor: "#f194ff",
    borderBottomColor: "gray",
    borderTopWidth: 1,
    borderLeftWidth: 7,
    borderRightWidth: 1,
    borderBottomWidth: 1
  },
  recipeName: {
    fontSize: 20,
  },
  panel: {
    alignItems: 'center'
  },
  input: {
    padding: 10,
    width: "90%",
    maxHeight: 200,
    borderBottomWidth: 3,
    borderLeftWidth: 1,
    borderRightWidth: 3,
    borderTopWidth: 1,
    borderBottomColor: '#333',
    borderTopColor: '#333',
    margin: 10,
  },
  button: {
    padding: 8,
    backgroundColor: 'green',
    borderRadius: 20,
    borderBottomWidth: 1,
    borderRightWidth: 1
  },
  buttonText: {
    fontSize: 14,
    color: '#ffffff'
  },
  buttonDiv: {
    display: "flex",
    flexDirection: "row",
  },
  commentDiv: {
    flex: 1,
    flexDirection: "row",
    justifyContent: "space-between",
    width: "80%",
    padding: 10,
    marginVertical: 5,
    marginHorizontal: 8,
    borderTopColor: "gray",
    borderLeftColor: "gray",
    borderBottomColor: "gray",
    borderRightColor: "blue",
    borderTopWidth: 1,
    borderLeftWidth: 1,
    borderRightWidth: 5,
    borderBottomWidth: 1
  },
  topText: {
    fontSize: 20,
    fontStyle: 'italic',
    backgroundColor: "pink",
    color: "blue",
    paddingLeft: 20
  }
});

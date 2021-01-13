// Shows all recipes of specific category.
import * as React from 'react';
import { SafeAreaView, FlatList, TouchableOpacity, View, Text, StyleSheet } from 'react-native';
import { jsonData } from "../json/ReceipJson";

function RecipesScreen({ route, navigation }) {
// receive categoryId and categoryName from before page(categories)
  const { categoryId, categoryName } = route.params;

  const DATA = jsonData.recipesList
  // Filter data with before categoryId
  const filterData = DATA.filter( element => element.categoryId ==categoryId)
  // return FlatList's data as item, pass props to Item: recipeName, recipeContent, navigation, id, categoryName
  const renderItem = ({ item }) => (
    <Item recipeName={item.recipeName} recipeContent={item.recipeContent}
      navigation={navigation} id={item.id} categoryName={categoryName}/>
  );

  const Item = ({ recipeName, navigation, id, categoryName }) => (
    // go to RecipeMethods page with id, categoryName, recipeName.
    <TouchableOpacity onPress={() => navigation.navigate('RecipeMethods', { id, categoryName, recipeName })}>
      <View style={styles.item}>
        <Text style={styles.recipeName}>{recipeName}</Text>
      </View>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.topText}>{categoryName}</Text>
      <FlatList
        data={filterData}
        renderItem={renderItem}
        keyExtractor={item => item.id.toString()}
      />
    </SafeAreaView>
  );
}

export default RecipesScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  item: {
    borderBottomWidth: 1,
    borderBottomColor: "gray",
    padding: 20,
    marginVertical: 8,
    marginHorizontal: 16,
  },
  recipeName: {
    fontSize: 20,
  },
  topText: {
    fontSize: 20,
    fontStyle: 'italic',
    backgroundColor: "pink",
    color: "blue",
    paddingLeft: 20
  }
});

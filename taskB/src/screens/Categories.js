// Shows all categories
import * as React from 'react';
import { SafeAreaView, FlatList, StyleSheet, View, Text, StatusBar, TouchableOpacity } from 'react-native';
import { jsonData } from "../json/ReceipJson";

function CategoriesScreen({ navigation }) {

  const DATA = jsonData.categoryList;

  // return FlatList's data as item, pass props to Item: categoryName, navigation, categoryId
  const renderItem = ({ item }) => (
    <Item categoryName={item.categoryName} navigation={navigation} categoryId={item.id} />
  );
  // return TouchableOpacity button as item
  const Item = ({ categoryName, navigation, categoryId }) => (
    // go to Recipes page with categoryId and categoryName.
    <TouchableOpacity onPress={() => navigation.navigate('Recipes', { categoryId, categoryName })}>
      <View style={styles.item}>
        <Text style={styles.categoryName}>{categoryName}</Text>
      </View>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      {/* Shows list of DATA */}
      <FlatList
        data={DATA}
        renderItem={renderItem}
        keyExtractor={item => item.id.toString()}
      />
    </SafeAreaView>
  );
}
export default CategoriesScreen;


const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginTop: StatusBar.currentHeight || 0,
  },
  item: {
    borderBottomWidth: 1,
    borderBottomColor: "gray",
    marginVertical: 10,
    marginHorizontal: 50,
  },
  categoryName: {
    fontSize: 20,
  },
});

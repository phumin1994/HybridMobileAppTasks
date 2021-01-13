import React, { useEffect, useState } from 'react';
import { View, FlatList, TouchableOpacity, SafeAreaView, Text, Image, StyleSheet} from 'react-native';
import * as SQLite from 'expo-sqlite';
import { getImg } from './actions/index';
import { connect } from 'react-redux';

const ProductViewAllScreen = ({ navigation, getImg, imgData  }) => {

  useEffect(() => {
    getImg();
    readData();
  }, []);

  const [ads, setAds] = useState([]);

  const readData = async () => {
    const db = SQLite.openDatabase('ads.db');
    db.transaction(tx => {
      tx.executeSql(
        "select * from ads",
        [],
        (trans, result) => {
          setAds(result.rows['_array']);
        },
        (error) => console.log("error fetching", error)
      );
    });
  }

  const renderItem = ({ item }) => (
    <Item id={item.imgId} description={item.description}
      navigation={navigation} />
  );

  const Item = ({ id, description}) => (
    <TouchableOpacity style={styles.adsItem}>
      <Image style={styles.adsItemImg} source={imgData[id]} />
      <Text style={styles.adsItemDescription}>{description}</Text>
    </TouchableOpacity>
  );
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <View style={{ flex: 1, backgroundColor: 'white' }}>
          <FlatList
            data={ads}
            renderItem={renderItem}
            keyExtractor={item => item.id.toString()}
          />
      </View>
    </SafeAreaView>
  );
};

const mapStateToProps = state => ({
  imgData: state,
});

const mapDispatchToProps = dispatch => ({
  getImg
});

export default connect(mapStateToProps, mapDispatchToProps)(ProductViewAllScreen)

const styles = StyleSheet.create({
  adsItem: {
    flex: 1,
    flexDirection: "row",
    borderBottomWidth: 1,
    borderBottomColor: "gray",
    paddingBottom: 5,
    paddingTop: 5
  },
  adsItemImg: {
    width: 100,
    height: 100,
    marginLeft: 20,
    borderWidth: 2,
    borderColor: 'yellow',
    borderRadius: 10
  },
  adsItemDescription: {
    paddingLeft: 5,
    alignSelf: 'center'
  },
});
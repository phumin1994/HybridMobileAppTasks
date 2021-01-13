import React, { useEffect, useState } from 'react';
import { View, FlatList, TouchableOpacity, SafeAreaView, Text, Image, StyleSheet, Alert } from 'react-native';
import * as SQLite from 'expo-sqlite';
import { getImg } from './actions/index';
import { connect } from 'react-redux';

const ProductViewMyScreen = ({ route, navigation, getImg, imgData }) => {

  useEffect(() => {
    getImg();
    const db = SQLite.openDatabase('ads.db');
    db.transaction(tx => {
      tx.executeSql(
        "select * from ads",
        [],
        (trans, result) => {
          const filterAds = result.rows['_array'].filter(element => element.userId == route.params.userId)
          console.log('failterAds', filterAds, route.params.userId)
          setAds(filterAds)
        },
        (error) => console.log("postData error fetching", error)
      );
    })
  }, []);

  const [ads, setAds] = useState([]);

  const deleteComment = (adsId) => {
    Alert.alert(
      "Confirm",
      "Do you want to delete this Ads?",
      [
        {
          text: "No",
          onPress: () => {
            console.log("Cancel Pressed")
          },
          style: "cancel"
        },
        { text: "Yes", onPress: () => {
          console.log("OK Pressed")
          const db = SQLite.openDatabase('ads.db');
          db.transaction(tx => {
            tx.executeSql(
              "delete from ads where id = ?",
              [adsId],
              (trans, result) => {
                const filterAds = result.rows['_array'].filter(element => element.userId == route.params.userId)
                console.log('failterAds', filterAds, route.params.userId)
                setAds(filterAds)
              },
              (error) => console.log("postData error fetching", error)
            );
          })
        } }
      ],
      { cancelable: false }
    );
  }

  const renderItem = ({ item }) => (
    <Item imgId={item.imgId} description={item.description} adsId={item.id}
      navigation={navigation} />
  );

  const Item = ({ imgId, description, adsId }) => (
    <TouchableOpacity style={styles.adsItem} onPress={() => navigation.navigate('UpdateShow', { adsId, imgId, description })}>
      <Image style={styles.adsItemImg} source={imgData[imgId]} />
      <View style={{flex: 1, flexDirection: "row", justifyContent: "space-between", padding: 15}}>
        <Text style={styles.adsItemDescription}>{description}</Text>
        <TouchableOpacity onPress={() => deleteComment(adsId)}>
          <Text>X</Text>
        </TouchableOpacity>
      </View>

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

export default connect(mapStateToProps, mapDispatchToProps)(ProductViewMyScreen)

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
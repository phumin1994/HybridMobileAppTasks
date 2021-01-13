const imgData = [
    require('../assets/img/Display/d1.jpg'),
    require('../assets/img/Display/d2.jpg'),
    require('../assets/img/Display/d3.jpg'),
    require('../assets/img/Display/d4.jpg'),
    require('../assets/img/Display/d5.jpg'),
    require('../assets/img/Display/d6.jpg'),
    require('../assets/img/Display/d7.jpg'),
    require('../assets/img/Display/d8.jpg'),
    require('../assets/img/Display/d9.jpg'),
    require('../assets/img/Display/d10.jpg'),
];

const imagesReducer = (state = [], action) => {
    switch (action.type) {
        case 'GET_IMG':
            console.log("get image data action")
            return imgData;
        default:
            return state
    }
}

export default imagesReducer;

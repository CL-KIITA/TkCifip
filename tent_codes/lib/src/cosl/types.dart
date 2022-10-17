import 'package:tent_codes/src/xilib.dart';
class OObject {}

typedef OPointerRaw = List<int>;
typedef KVPair<K, V> = MapEntry<K, V>;
const int nullPtr = -1;

class OPointedObject<T extends OObject> extends OObject {
  final int pointer;
  final T data;
  OPointedObject(this.pointer, this.data);
  factory OPointedObject.nullPtr(T data) => OPointedObject<T>(nullPtr, data);
  OPointedObject<T> clone({int? pointer, T? data}) => OPointedObject<T>(pointer != null ? pointer : this.pointer, data != null ? data : this.data);
}
//Todo: OFunctionクラス
/*
class OFunction extends OObject{}
*/
class OList<E extends OObject> extends OObject {
  OPointerRaw _index = [];
  List<OPointedObject<E>> _data = [];
  OList();
  void add(E element) {
    if(this._index.isEmpty || this._data.isEmpty){
      if(this._data.isEmpty){
        //データが皆無
        this._index.add(0);
        this._data.add(OPointedObject.nullPtr(element));
      }else{
        //ゴミデータはあるが無効
        this._index.add(this._data.length);
        this._data.add(OPointedObject.nullPtr(element));
      }
    }else{
      this._data[this._index[this._index.length - 1]] = this._data[this._index[this._index.length - 1]].clone(pointer: this._data.length);
      this._index.add(this._data.length);
      this._data.add(OPointedObject.nullPtr(element));
    }
  }
  void insert(int index, E element) {
    if(index < 0 || this._index.length < index){
      throw RangeError.range(index, 0, this._index.length);
    }else if(this._index.length == index){
      print("insert redirect to add");
      this.add(element);
    }else{
      //Todo: Empty時対策(add参照)
      int postPtr = this._index[index];
      int lastPtr = this._data.length;
      print("post: $postPtr, last: $lastPtr");
      this._index.insert(index, lastPtr);
      this._data.add(OPointedObject<E>(postPtr, element));
      this._data[this._index[index - 1]] = this._data[this._index[index - 1]].clone(pointer: lastPtr);
    }
  }
  void addAll(List<E> elements) => elements.forEach((E e) => this.add(e));
  void insertAll(List<KVPair<int, E>> pairs) => pairs.forEach((KVPair<int, E> pair) => this.insert(pair.key, pair.value));
  void removeAt(int index) {
    if(index < 0 || this._index.length - 1 < index){
      throw RangeError.range(index, 0, this._index.length - 1);
    }
    int currPointedPointer = this._data[this._index[index]].pointer;
    this._data[this._index[index -1]] = this._data[this._index[index -1]].clone(pointer: currPointedPointer);
    this._index.removeAt(index);
  }
  void removeLast() => this.removeAt(this.length - 1);
  //Todo: 高関数関数系関数の実装。（OFunctionクラスが未成のため
  /*
  OList<R> map<R>(OFunction);
  void forEach(OFunction);
  E reduce(OFunction);
  E fold(E, OFunction);
   */
  void compaction(){
    //Todo: まともに機能していない。修正要す
    List<int> markedIndex = [];
    for(int i = 0; i < this._data.length; i++){
      if(this._index.every((int ind) => ind != i)){
        markedIndex.add(i);
      }
    }
    markedIndex.sort();
    List<int> prevSubPtr = List<int>.filled(this._index.length, 0);
    int pos = 0;
    int cnt = 0;
    print(markedIndex);
    for (int j = 0 ; j < markedIndex.length; j++){
      print("b-if: ${markedIndex[j]}");
      if(markedIndex[j] - ((j == 0) ? 0 : markedIndex[j - 1]) > 1){
        prevSubPtr[pos] = cnt;
        pos++;
        cnt = 0;
      }else{
        cnt++;
      }
    }
    for(int k = 1; k < prevSubPtr.length; k++){
      prevSubPtr[k] = prevSubPtr[k] + prevSubPtr[k - 1];
    }
    for(int l = 0; l < this._index.length; l++){
      this._index[l] = this._index[l] - prevSubPtr[l];
      if(l + 1 < this._index.length){
        this._data[this._index[l]] = this._data[this._index[l]].clone(pointer: this._data[this._index[l]].pointer - prevSubPtr[l + 1]);
      }
    }
    List<int> removeIndex = markedIndex.reversed.toList();
    for ( var m = 0 ; m < removeIndex.length ; m++){
      this._data.removeAt(removeIndex[m]);
    }
  }
  int get length => this._index.length;
  E operator [](int index) => this._data[this._index[index]].data;
  void operator []=(int index, E value) => this._data[this._index[index]] = this._data[this._index[index]].clone(data: value);
  String showFmt(){
    String index = this._index.indexedMap<String>((int i, int e) => "<$i: $e>").join(", ");
    String data = this._data.indexedMap<String>((int i, OPointedObject<E> e) => "<$i: ${e.pointer}, ${e.data}>").join(", ");
    return "index: {$index}\ndata: {$data}";
  }
}

class ONumber extends OObject {}

class OInteger extends ONumber {
  final int nr;
  OInteger(this.nr);
  @override
  String toString() {
    return "OInteger(${this.nr})";
  }
}
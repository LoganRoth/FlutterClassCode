import 'package:flutter/material.dart';
import 'package:meal_app/items/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  final Function saveFilters;
  final Map<String, bool> curFilters;

  FiltersScreen(this.saveFilters, this.curFilters);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _glutenFree = false;
  bool _vegetarian = false;
  bool _vegan = false;
  bool _lactoseFree = false;

  @override
  initState() {
    _glutenFree = widget.curFilters['gf'];
    _vegetarian = widget.curFilters['vgt'];
    _vegan = widget.curFilters['v'];
    _lactoseFree = widget.curFilters['lf'];
    super.initState();
  }

  Widget _buildSwitchListTile(String title, bool curVal, Function updateVal) {
    return SwitchListTile(
      title: Text(title),
      value: curVal,
      subtitle: Text(
        'Only include $title meals.',
      ),
      onChanged: updateVal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Filters'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final Map<String, bool> selectedFilters = {
                'gf': _glutenFree,
                'vgt': _vegetarian,
                'v': _vegan,
                'lf': _lactoseFree,
              };
              widget.saveFilters(selectedFilters);
            },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Text('Adjust your meal selection',
                style: Theme.of(context).textTheme.title),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildSwitchListTile('Gluten Free', _glutenFree, (newVal) {
                  setState(() {
                    _glutenFree = newVal;
                  });
                }),
                _buildSwitchListTile('Vegetarian', _vegetarian, (newVal) {
                  setState(() {
                    _vegetarian = newVal;
                  });
                }),
                _buildSwitchListTile('Vegan', _vegan, (newVal) {
                  setState(() {
                    _vegan = newVal;
                  });
                }),
                _buildSwitchListTile('Lactose Free', _lactoseFree, (newVal) {
                  setState(() {
                    _lactoseFree = newVal;
                  });
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

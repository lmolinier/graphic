/// Graphic provides a Flutter charting library for data visualization. it has a
/// chart widget, classes for specification, and some util classes and funtions
/// for customization.
///
/// To use this charting library, you only need to do one thing: to create a [Chart]
/// widget. This widget will evaluate and paint automatically in initial and on
/// update.
///
/// A start example of bar chart is as below:
///
/// ```dart
/// Chart(
///   data: [
///     { 'genre': 'Sports', 'sold': 275 },
///     { 'genre': 'Strategy', 'sold': 115 },
///     { 'genre': 'Action', 'sold': 120 },
///     { 'genre': 'Shooter', 'sold': 350 },
///     { 'genre': 'Other', 'sold': 150 },
///   ],
///   variables: {
///     'genre': Variable(
///       accessor: (Map map) => map['genre'] as String,
///     ),
///     'sold': Variable(
///       accessor: (Map map) => map['sold'] as num,
///     ),
///   },
///   marks: [IntervalMark()],
///   axes: [
///     Defaults.horizontalAxis,
///     Defaults.verticalAxis,
///   ],
/// )
/// ```
///
/// All specifications of data visualization are set by parameters of [Chart]'s
/// constructor as class properties.
///
/// The main processing flow of charting and some important concepts are as below.
/// Most concepts derive form the Grammar of Graphics. They will help to take full
/// advantage of this library. These are brif introcuction, and details see into
/// the Classes and [Chart] properties.
///
/// ```
///    variable    scale           aesthetic                  shape
///       |          |                 |                        |
/// data --> tuples --> scaled tuples --> aesthetic encodes --> elements
/// ```
///
/// ## Variable
///
/// Variables define the fields of [Tuple]s. The input data of the chart is a [List]
/// of any generic type. Yet they are not used directly inside the chart, instead,
/// the data are converted to [Tuple]s.
///
/// They are specified by [Chart.variables] or [Chart.transforms] with [Variable] or
/// [VariableTransform].
///
/// ## Algebra
///
/// The graphic algebra determins how variable values are assigned to position dimensions.
///
/// It is specified by [Mark.position] with [Varset]. See details of the algebra
/// rules in [Varset].
///
/// ## Scale
///
/// Scales convert [Tuple] values to to scaled values, which is easier to prosess
/// for aesthetic [Encode]s.
///
/// They are specified by [Variable.scale] with [Scale].
///
/// ## Coordinate
///
/// The coordinate determins how abstract positions are located on the canvas in
/// painting. The same mark may look quite different in [RectCoord] and [PolarCoord].
///
/// It is specified by [Chart.coord] with [Coord].
///
/// ## Aesthetic
///
/// Aesthetic means to make [Tuple]s percivable. That is to give them aesthetic encodes
/// from the scaled values.
///
/// Aesthetic encodes are specified in [Mark] with [Encode]. And encodes
/// values are stored in [Attributes].
///
/// ## Shape
///
/// Shapes render [Tuple]s with [Attributes] encodes. Rendering means to get [MarkElement]s,
/// which carry the painting information for the rendering engine. Extending a shape
/// subclass is the way to custom charts.
///
/// Shape is also a aesthetic encode is self. It is defined with [Shape], and
/// generated by [ShapeEncode] wich is defined by [Mark.shape]. The [Shape]
/// type should corresponds to [Mark] type.
///
/// ## Interaction
///
/// There are two kinds of interactions: [Event] and [Selection]. Event means
/// a certain specification value changes to [GestureEvent], [ResizeEvent], or
/// [ChangeDataEvent]. Selection means a tuple aesthetic encode values change
/// when it is selected or not.
///
/// Events are used by event streams specified in [Chart]. Selections
/// are specified by [Chart.selections] and used by [Encode.updaters] with [SelectionUpdater].
///
/// ## Guide
///
/// Guides are various components that helps to read the chart.
///
/// They include [Axis] specified by [Chart.axes], [Tooltip] specified by [Chart.tooltip],
/// [Crosshair] specified by [Chart.crosshair], and [Annotation]s specified by [Chart.annotations],
///
/// ## Animation
/// Marks can specify transition animation by [Mark.transition] on entrance or changed.
/// [Mark.entrance] defines which encode attributes are zero at the begining of
/// entrance animation.
library graphic;

export 'src/chart/chart.dart' show Chart;
export 'src/chart/size.dart' show ResizeEvent;

export 'src/data/data_set.dart' show ChangeDataEvent;

export 'src/variable/variable.dart' show Variable;
export 'src/variable/transform/transform.dart' show VariableTransform;
export 'src/variable/transform/filter.dart' show Filter;
export 'src/variable/transform/map.dart' show MapTrans;
export 'src/variable/transform/proportion.dart' show Proportion;
export 'src/variable/transform/sort.dart' show Sort;

export 'src/scale/scale.dart' show Scale, ScaleConv;
export 'src/scale/discrete.dart' show DiscreteScale, DiscreteScaleConv;
export 'src/scale/continuous.dart' show ContinuousScale, ContinuousScaleConv;
export 'src/scale/linear.dart' show LinearScale, LinearScaleConv;
export 'src/scale/logarithmic.dart' show LogarithmicScale, LogarithmicScaleConv;
export 'src/scale/ordinal.dart' show OrdinalScale, OrdinalScaleConv;
export 'src/scale/time.dart' show TimeScale, TimeScaleConv;
export 'src/scale/util/nice_numbers.dart' show linearNiceNumbers;
export 'src/scale/util/nice_range.dart' show linearNiceRange;

export 'src/mark/mark.dart' show Mark, MarkEntrance;
export 'src/mark/function.dart' show FunctionMark;
export 'src/mark/partition.dart' show PartitionMark;
export 'src/mark/area.dart' show AreaMark;
export 'src/mark/custom.dart' show CustomMark;
export 'src/mark/interval.dart' show IntervalMark;
export 'src/mark/line.dart' show LineMark;
export 'src/mark/point.dart' show PointMark;
export 'src/mark/polygon.dart' show PolygonMark;
export 'src/mark/modifier/modifier.dart' show Modifier;
export 'src/mark/modifier/dodge.dart' show DodgeModifier;
export 'src/mark/modifier/stack.dart' show StackModifier;
export 'src/mark/modifier/jitter.dart' show JitterModifier;
export 'src/mark/modifier/symmetric.dart' show SymmetricModifier;

export 'src/encode/encode.dart' show Encode;
export 'src/encode/channel.dart' show ChannelEncode;
export 'src/encode/color.dart' show ColorEncode;
export 'src/encode/elevation.dart' show ElevationEncode;
export 'src/encode/gradient.dart' show GradientEncode;
export 'src/encode/label.dart' show LabelEncode;
export 'src/encode/shape.dart' show ShapeEncode;
export 'src/encode/size.dart' show SizeEncode;

export 'src/algebra/varset.dart' show Varset, AlgForm, AlgTerm;

export 'src/shape/shape.dart' show Shape;
export 'src/shape/function.dart' show FunctionShape;
export 'src/shape/partition.dart' show PartitionShape;
export 'src/shape/area.dart' show AreaShape, BasicAreaShape;
export 'src/shape/custom.dart' show CandlestickShape;
export 'src/shape/interval.dart' show IntervalShape, RectShape, FunnelShape;
export 'src/shape/line.dart' show LineShape, BasicLineShape;
export 'src/shape/point.dart' show PointShape, CircleShape, SquareShape;
export 'src/shape/polygon.dart' show PolygonShape, HeatmapShape;
export 'src/shape/bitmap.dart' show HistoricHeatmapBitmapShape, HeatmapBitmapShape;
export 'src/shape/util/style.dart' show getPaintStyle;

export 'src/graffiti/transition.dart' show Transition;
export 'src/graffiti/element/element.dart'
    show MarkElement, PaintStyle, PrimitiveElement, getBlockPaintPoint;
export 'src/graffiti/element/arc.dart' show ArcElement;
export 'src/graffiti/element/circle.dart' show CircleElement;
export 'src/graffiti/element/group.dart' show GroupElement;
export 'src/graffiti/element/image.dart' show ImageElement, ImageStyle;
export 'src/graffiti/element/picture.dart' show PictureElement, PictureStyle;
export 'src/graffiti/element/label.dart' show LabelElement, LabelStyle;
export 'src/graffiti/element/line.dart' show LineElement;
export 'src/graffiti/element/oval.dart' show OvalElement;
export 'src/graffiti/element/path.dart' show PathElement;
export 'src/graffiti/element/polygon.dart' show PolygonElement;
export 'src/graffiti/element/polyline.dart' show PolylineElement;
export 'src/graffiti/element/rect.dart' show RectElement;
export 'src/graffiti/element/sector.dart' show SectorElement;
export 'src/graffiti/element/spline.dart' show SplineElement;
export 'src/graffiti/element/segment/segment.dart' show Segment, SegmentTags;
export 'src/graffiti/element/segment/arc_to_point.dart' show ArcToPointSegment;
export 'src/graffiti/element/segment/arc.dart' show ArcSegment;
export 'src/graffiti/element/segment/close.dart' show CloseSegment;
export 'src/graffiti/element/segment/conic.dart' show ConicSegment;
export 'src/graffiti/element/segment/cubic.dart' show CubicSegment;
export 'src/graffiti/element/segment/line.dart' show LineSegment;
export 'src/graffiti/element/segment/move.dart' show MoveSegment;
export 'src/graffiti/element/segment/quadratic.dart' show QuadraticSegment;

export 'src/coord/coord.dart' show Coord, CoordConv;
export 'src/coord/polar.dart' show PolarCoord, PolarCoordConv;
export 'src/coord/rect.dart' show RectCoord, RectCoordConv;

export 'src/guide/axis/axis.dart'
    show TickLine, TickLineMapper, LabelMapper, GridMapper, AxisGuide;
export 'src/guide/interaction/tooltip.dart' show TooltipGuide, TooltipRenderer;
export 'src/guide/interaction/crosshair.dart' show CrosshairGuide;
export 'src/guide/annotation/annotation.dart' show Annotation;
export 'src/guide/annotation/element.dart' show ElementAnnotation;
export 'src/guide/annotation/line.dart' show LineAnnotation;
export 'src/guide/annotation/region.dart' show RegionAnnotation;
export 'src/guide/annotation/tag.dart' show TagAnnotation;
export 'src/guide/annotation/custom.dart' show CustomAnnotation;

export 'src/interaction/event.dart' show Event, EventType, EventUpdater;
export 'src/interaction/gesture.dart' show GestureType, Gesture, GestureEvent;
export 'src/interaction/selection/selection.dart'
    show Selection, Selected, SelectionUpdater;
export 'src/interaction/selection/interval.dart' show IntervalSelection;
export 'src/interaction/selection/point.dart' show PointSelection;

export 'src/common/label.dart' show Label;
export 'src/common/defaults.dart' show Defaults;
export 'src/common/dim.dart' show Dim;

export 'src/dataflow/tuple.dart' show Tuple, Attributes, AttributesGroups;

export 'package:path_drawing/path_drawing.dart' show DashOffset;

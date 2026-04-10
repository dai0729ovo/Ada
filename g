import React, { useState, useEffect, useMemo } from 'react';
import { 
  ShoppingBag, 
  Menu, 
  X, 
  ChevronRight, 
  Sun, 
  Wind, 
  Battery, 
  ShieldCheck, 
  ArrowRight,
  CreditCard,
  CheckCircle2,
  Trash2,
  Minus,
  Plus
} from 'lucide-react';

// 初始产品数据
const INITIAL_PRODUCTS = [
  {
    id: 'solaer-v1',
    name: 'SOLAER V1 - Signature Edition',
    price: 299.00,
    description: '采用航天级铝材打造，搭载最新的太阳能捕捉技术。',
    specs: {
      efficiency: '24.5% 转化率',
      battery: '15,000mAh',
      weight: '1.2kg',
      noise: '< 30dB'
    },
    stock: 5,
    image: 'https://images.unsplash.com/photo-1619200018503-463e26407153?auto=format&fit=crop&q=80&w=1000' // 模拟风扇/极简产品图
  },
  {
    id: 'solaer-mini',
    name: 'SOLAER Go - Portable',
    price: 149.00,
    description: '轻便至极，专为户外探险者设计的折叠式太阳能动力源。',
    specs: {
      efficiency: '22.0% 转化率',
      battery: '8,000mAh',
      weight: '0.6kg',
      noise: '< 25dB'
    },
    stock: 12,
    image: 'https://images.unsplash.com/photo-1544724569-5f546fd6f2b5?auto=format&fit=crop&q=80&w=1000'
  }
];

const App = () => {
  const [view, setView] = useState('home'); // home, product, cart, checkout, success
  const [selectedProduct, setSelectedProduct] = useState(null);
  const [cart, setCart] = useState([]);
  const [products, setProducts] = useState(INITIAL_PRODUCTS);
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  // 模拟库存同步：下单减库存逻辑
  const updateStock = (items) => {
    const newProducts = products.map(p => {
      const cartItem = items.find(item => item.id === p.id);
      if (cartItem) {
        return { ...p, stock: Math.max(0, p.stock - cartItem.quantity) };
      }
      return p;
    });
    setProducts(newProducts);
  };

  // 购物车逻辑
  const addToCart = (product) => {
    if (product.stock <= 0) return;
    setCart(prev => {
      const existing = prev.find(item => item.id === product.id);
      if (existing) {
        return prev.map(item => item.id === product.id ? { ...item, quantity: item.quantity + 1 } : item);
      }
      return [...prev, { ...product, quantity: 1 }];
    });
    setView('cart');
  };

  const removeFromCart = (id) => setCart(prev => prev.filter(item => item.id !== id));
  
  const cartTotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);

  // 页面切换组件
  const navigateTo = (v, data = null) => {
    setView(v);
    if (data) setSelectedProduct(data);
    window.scrollTo(0, 0);
  };

  // 导航栏
  const Navbar = () => (
    <nav className="fixed top-0 left-0 w-full z-50 flex items-center justify-between px-8 py-6 mix-blend-difference text-white">
      <div className="text-2xl font-bold tracking-tighter cursor-pointer" onClick={() => navigateTo('home')}>
        SOLAER
      </div>
      <div className="hidden md:flex space-x-12 text-sm uppercase tracking-widest font-medium">
        <a href="#" className="hover:opacity-50 transition-opacity">Technology</a>
        <a href="#" className="hover:opacity-50 transition-opacity">Sustainability</a>
        <a href="#" className="hover:opacity-50 transition-opacity">Journal</a>
      </div>
      <div className="flex items-center space-x-6">
        <button onClick={() => setView('cart')} className="relative p-2">
          <ShoppingBag size={22} />
          {cart.length > 0 && (
            <span className="absolute top-0 right-0 bg-[#004D40] text-white text-[10px] w-4 h-4 rounded-full flex items-center justify-center">
              {cart.reduce((a, b) => a + b.quantity, 0)}
            </span>
          )}
        </button>
        <button className="md:hidden" onClick={() => setIsMenuOpen(true)}>
          <Menu size={22} />
        </button>
      </div>
    </nav>
  );

  // 1. 首页 (Hero Section)
  const HomePage = () => (
    <div className="relative min-h-screen bg-[#F5F5F7] overflow-hidden">
      <div className="absolute inset-0 z-0">
        <img 
          src="https://images.unsplash.com/photo-1591115785333-290b752c9df4?auto=format&fit=crop&q=80&w=2000" 
          alt="Solar Fan Hero"
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-black/20"></div>
      </div>
      
      <div className="relative z-10 flex flex-col items-center justify-center min-h-screen text-center text-white px-4">
        <h2 className="text-sm uppercase tracking-[0.3em] mb-4 opacity-80">Solar Powered Excellence</h2>
        <h1 className="text-5xl md:text-8xl font-light tracking-tight mb-8">
          Capture the Sun,<br />Feel the Breeze
        </h1>
        <div className="flex space-x-4">
          <button 
            onClick={() => {
              const el = document.getElementById('products');
              el.scrollIntoView({ behavior: 'smooth' });
            }}
            className="px-8 py-4 bg-white/10 backdrop-blur-md border border-white/20 rounded-full text-sm font-medium hover:bg-white hover:text-black transition-all duration-500"
          >
            探索系列
          </button>
          <button 
            onClick={() => addToCart(products[0])}
            className="px-8 py-4 bg-[#004D40] rounded-full text-sm font-medium hover:bg-[#00352c] transition-all flex items-center"
          >
            一键购买 <ChevronRight size={16} className="ml-1" />
          </button>
        </div>
      </div>

      {/* 产品网格 */}
      <section id="products" className="py-32 px-8 bg-white">
        <div className="max-w-7xl mx-auto">
          <div className="mb-20">
            <h3 className="text-3xl font-light text-gray-900">精选产品</h3>
            <div className="h-px w-20 bg-[#004D40] mt-4"></div>
          </div>
          
          <div className="grid md:grid-cols-2 gap-12">
            {products.map(product => (
              <div 
                key={product.id}
                className="group cursor-pointer"
                onClick={() => navigateTo('product', product)}
              >
                <div className="aspect-[4/5] overflow-hidden bg-[#F9F9FB] rounded-2xl relative">
                  <img 
                    src={product.image} 
                    alt={product.name}
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700"
                  />
                  {product.stock <= 0 && (
                    <div className="absolute inset-0 bg-white/60 flex items-center justify-center backdrop-blur-sm">
                      <span className="px-6 py-2 border border-gray-400 text-gray-600 uppercase tracking-widest text-xs font-bold">已售罄</span>
                    </div>
                  )}
                  <div className="absolute top-6 left-6">
                    <span className={`text-[10px] px-3 py-1 rounded-full uppercase tracking-tighter font-bold ${product.stock > 0 ? 'bg-[#004D40] text-white' : 'bg-gray-200 text-gray-500'}`}>
                      {product.stock > 0 ? `仅剩 ${product.stock} 件` : 'SOLD OUT'}
                    </span>
                  </div>
                </div>
                <div className="mt-8 flex justify-between items-end">
                  <div>
                    <h4 className="text-xl font-light text-gray-800">{product.name}</h4>
                    <p className="text-gray-400 mt-1">${product.price.toFixed(2)} USD</p>
                  </div>
                  <button className="w-10 h-10 rounded-full border border-gray-200 flex items-center justify-center group-hover:bg-black group-hover:text-white transition-colors">
                    <ArrowRight size={18} />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>
    </div>
  );

  // 2. 产品详情页 (Product Detail)
  const ProductDetail = ({ product }) => (
    <div className="pt-24 min-h-screen bg-white">
      <div className="max-w-7xl mx-auto px-8 py-12 grid md:grid-cols-2 gap-20">
        <div className="space-y-6">
          <div className="aspect-square bg-[#F9F9FB] rounded-3xl overflow-hidden">
            <img src={product.image} className="w-full h-full object-cover" alt={product.name} />
          </div>
          <div className="grid grid-cols-3 gap-4">
             {[1,2,3].map(i => <div key={i} className="aspect-square bg-[#F9F9FB] rounded-xl"></div>)}
          </div>
        </div>
        
        <div className="flex flex-col justify-center">
          <nav className="flex space-x-2 text-xs uppercase tracking-widest text-gray-400 mb-8">
            <span className="cursor-pointer" onClick={() => setView('home')}>Home</span>
            <span>/</span>
            <span className="text-black">Products</span>
          </nav>
          
          <h1 className="text-4xl font-light mb-4">{product.name}</h1>
          <p className="text-2xl text-[#004D40] mb-8">${product.price.toFixed(2)}</p>
          
          <p className="text-gray-600 leading-relaxed mb-10 italic">
            "{product.description}"
          </p>

          <div className="grid grid-cols-2 gap-6 mb-12 border-t border-b border-gray-100 py-8">
            <div className="flex items-center space-x-3">
              <Sun size={20} className="text-[#004D40]" />
              <div>
                <p className="text-[10px] uppercase text-gray-400">效率</p>
                <p className="text-sm font-medium">{product.specs.efficiency}</p>
              </div>
            </div>
            <div className="flex items-center space-x-3">
              <Battery size={20} className="text-[#004D40]" />
              <div>
                <p className="text-[10px] uppercase text-gray-400">容量</p>
                <p className="text-sm font-medium">{product.specs.battery}</p>
              </div>
            </div>
            <div className="flex items-center space-x-3">
              <Wind size={20} className="text-[#004D40]" />
              <div>
                <p className="text-[10px] uppercase text-gray-400">噪音</p>
                <p className="text-sm font-medium">{product.specs.noise}</p>
              </div>
            </div>
            <div className="flex items-center space-x-3">
              <ShieldCheck size={20} className="text-[#004D40]" />
              <div>
                <p className="text-[10px] uppercase text-gray-400">质保</p>
                <p className="text-sm font-medium">2年 全球联保</p>
              </div>
            </div>
          </div>

          <button 
            disabled={product.stock <= 0}
            onClick={() => addToCart(product)}
            className={`w-full py-5 rounded-full text-sm font-bold uppercase tracking-widest transition-all ${
              product.stock > 0 
              ? 'bg-black text-white hover:bg-[#004D40]' 
              : 'bg-gray-100 text-gray-400 cursor-not-allowed'
            }`}
          >
            {product.stock > 0 ? '加入购物车' : '暂时售罄'}
          </button>
        </div>
      </div>
    </div>
  );

  // 3. 购物车系统 (Cart System)
  const CartPage = () => (
    <div className="pt-24 min-h-screen bg-[#F9F9FB]">
      <div className="max-w-4xl mx-auto px-8 py-12">
        <h2 className="text-3xl font-light mb-12">购物袋</h2>
        
        {cart.length === 0 ? (
          <div className="bg-white p-20 text-center rounded-3xl border border-gray-100">
            <ShoppingBag className="mx-auto mb-6 text-gray-200" size={48} />
            <p className="text-gray-500 mb-8">您的购物袋还是空的</p>
            <button onClick={() => setView('home')} className="underline text-sm uppercase tracking-widest">返回选购</button>
          </div>
        ) : (
          <div className="space-y-8">
            <div className="bg-white rounded-3xl p-8 shadow-sm">
              {cart.map(item => (
                <div key={item.id} className="flex items-center justify-between py-6 border-b last:border-0 border-gray-50">
                  <div className="flex items-center space-x-6">
                    <img src={item.image} className="w-20 h-20 rounded-xl object-cover bg-gray-50" alt="" />
                    <div>
                      <h4 className="font-medium">{item.name}</h4>
                      <p className="text-sm text-gray-400 mt-1">${item.price.toFixed(2)}</p>
                    </div>
                  </div>
                  <div className="flex items-center space-x-4">
                    <div className="flex items-center border border-gray-100 rounded-full px-3 py-1">
                      <button onClick={() => removeFromCart(item.id)} className="p-1 hover:text-[#004D40]"><Minus size={14} /></button>
                      <span className="mx-4 text-sm">{item.quantity}</span>
                      <button onClick={() => addToCart(item)} className="p-1 hover:text-[#004D40]"><Plus size={14} /></button>
                    </div>
                    <button onClick={() => removeFromCart(item.id)} className="text-gray-300 hover:text-red-400">
                      <Trash2 size={18} />
                    </button>
                  </div>
                </div>
              ))}
            </div>
            
            <div className="bg-white rounded-3xl p-8 shadow-sm">
              <div className="flex justify-between items-center mb-6">
                <span className="text-gray-400">小计</span>
                <span className="text-2xl font-light">${cartTotal.toFixed(2)}</span>
              </div>
              <button 
                onClick={() => setView('checkout')}
                className="w-full py-5 bg-[#004D40] text-white rounded-full text-sm font-bold uppercase tracking-widest hover:bg-[#00352c] transition-all"
              >
                前往结算
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );

  // 4. 支付集成 (Checkout)
  const CheckoutPage = () => {
    const [loading, setLoading] = useState(false);

    const handlePayment = (e) => {
      e.preventDefault();
      setLoading(true);
      // 模拟支付 API 调用
      setTimeout(() => {
        updateStock(cart);
        setCart([]);
        setLoading(false);
        setView('success');
      }, 2000);
    };

    return (
      <div className="pt-24 min-h-screen bg-white">
        <div className="max-w-5xl mx-auto px-8 py-12 grid md:grid-cols-2 gap-20">
          <div>
            <h2 className="text-2xl font-light mb-10 flex items-center">
              <CreditCard className="mr-3" /> 支付信息
            </h2>
            <form onSubmit={handlePayment} className="space-y-6">
              <div className="space-y-2">
                <label className="text-[10px] uppercase text-gray-400 tracking-widest">Cardholder Name</label>
                <input required type="text" className="w-full px-6 py-4 bg-[#F9F9FB] rounded-xl focus:outline-none focus:ring-1 focus:ring-[#004D40]" placeholder="John Doe" />
              </div>
              <div className="space-y-2">
                <label className="text-[10px] uppercase text-gray-400 tracking-widest">Card Number</label>
                <input required type="text" className="w-full px-6 py-4 bg-[#F9F9FB] rounded-xl focus:outline-none focus:ring-1 focus:ring-[#004D40]" placeholder="•••• •••• •••• ••••" />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <label className="text-[10px] uppercase text-gray-400 tracking-widest">Expiry</label>
                  <input required type="text" className="w-full px-6 py-4 bg-[#F9F9FB] rounded-xl focus:outline-none focus:ring-1 focus:ring-[#004D40]" placeholder="MM/YY" />
                </div>
                <div className="space-y-2">
                  <label className="text-[10px] uppercase text-gray-400 tracking-widest">CVC</label>
                  <input required type="password" size="3" className="w-full px-6 py-4 bg-[#F9F9FB] rounded-xl focus:outline-none focus:ring-1 focus:ring-[#004D40]" placeholder="•••" />
                </div>
              </div>
              <div className="pt-6">
                <button 
                  disabled={loading}
                  className="w-full py-5 bg-black text-white rounded-full text-sm font-bold uppercase tracking-widest hover:opacity-80 transition-all flex items-center justify-center"
                >
                  {loading ? (
                    <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
                  ) : `确认付款 $${cartTotal.toFixed(2)}`}
                </button>
              </div>
              <p className="text-[10px] text-center text-gray-400 mt-4 uppercase tracking-widest flex items-center justify-center">
                <ShieldCheck size={12} className="mr-1" /> Secure encrypted payment via Stripe
              </p>
            </form>
          </div>
          
          <div className="bg-[#F9F9FB] rounded-3xl p-10 h-fit">
            <h3 className="text-lg font-medium mb-6">订单摘要</h3>
            <div className="space-y-4 mb-10">
              {cart.map(item => (
                <div key={item.id} className="flex justify-between text-sm">
                  <span className="text-gray-500">{item.name} x {item.quantity}</span>
                  <span>${(item.price * item.quantity).toFixed(2)}</span>
                </div>
              ))}
            </div>
            <div className="border-t border-gray-200 pt-6 flex justify-between items-center">
              <span className="text-gray-400">总计</span>
              <span className="text-3xl font-light text-[#004D40]">${cartTotal.toFixed(2)}</span>
            </div>
          </div>
        </div>
      </div>
    );
  };

  // 成功页面
  const SuccessPage = () => (
    <div className="min-h-screen flex items-center justify-center px-8">
      <div className="max-w-md w-full text-center space-y-8">
        <div className="w-24 h-24 bg-[#E0F2F1] rounded-full flex items-center justify-center mx-auto text-[#004D40]">
          <CheckCircle2 size={48} />
        </div>
        <div>
          <h2 className="text-4xl font-light mb-4">支付成功</h2>
          <p className="text-gray-500 leading-relaxed">
            感谢您为清洁能源贡献一份力量。您的 SOLAER 风扇已进入库存锁定，我们将在 24 小时内为您发货。
          </p>
        </div>
        <button 
          onClick={() => setView('home')}
          className="px-10 py-4 border border-black rounded-full text-xs uppercase tracking-widest hover:bg-black hover:text-white transition-all"
        >
          返回首页
        </button>
      </div>
    </div>
  );

  return (
    <div className="font-['Inter',_sans-serif] text-slate-900 selection:bg-[#004D40] selection:text-white">
      <Navbar />
      
      {/* 侧边导航栏 (Mobile) */}
      {isMenuOpen && (
        <div className="fixed inset-0 z-[100] bg-white p-12 flex flex-col justify-between">
          <div className="flex justify-between items-center">
            <div className="text-2xl font-bold tracking-tighter">SOLAER</div>
            <button onClick={() => setIsMenuOpen(false)}><X size={32} /></button>
          </div>
          <div className="space-y-8 text-4xl font-light">
            <div className="block hover:text-[#004D40] cursor-pointer" onClick={() => { setView('home'); setIsMenuOpen(false); }}>Collection</div>
            <div className="block hover:text-[#004D40] cursor-pointer">Technology</div>
            <div className="block hover:text-[#004D40] cursor-pointer">Our Mission</div>
          </div>
          <div className="text-[10px] uppercase tracking-[0.2em] text-gray-400">© 2024 SOLAER INTERNATIONAL</div>
        </div>
      )}

      <main className="transition-opacity duration-500">
        {view === 'home' && <HomePage />}
        {view === 'product' && <ProductDetail product={selectedProduct} />}
        {view === 'cart' && <CartPage />}
        {view === 'checkout' && <CheckoutPage />}
        {view === 'success' && <SuccessPage />}
      </main>

      <footer className="bg-[#F5F5F7] py-20 px-8">
        <div className="max-w-7xl mx-auto grid md:grid-cols-4 gap-12">
          <div className="col-span-2">
            <h2 className="text-2xl font-bold tracking-tighter mb-8 text-[#004D40]">SOLAER</h2>
            <p className="text-gray-500 max-w-xs leading-relaxed text-sm">
              致力于通过极简设计与高效能源技术，为全球用户提供可持续的清凉解决方案。
            </p>
          </div>
          <div>
            <h4 className="text-[10px] uppercase tracking-widest mb-6 font-bold">Shop</h4>
            <ul className="space-y-4 text-sm text-gray-600">
              <li className="hover:text-black cursor-pointer">Signature V1</li>
              <li className="hover:text-black cursor-pointer">Solaer Go</li>
              <li className="hover:text-black cursor-pointer">Accessories</li>
            </ul>
          </div>
          <div>
            <h4 className="text-[10px] uppercase tracking-widest mb-6 font-bold">Support</h4>
            <ul className="space-y-4 text-sm text-gray-600">
              <li className="hover:text-black cursor-pointer">Shipping</li>
              <li className="hover:text-black cursor-pointer">Returns</li>
              <li className="hover:text-black cursor-pointer">Contact</li>
            </ul>
          </div>
        </div>
        <div className="max-w-7xl mx-auto border-t border-gray-200 mt-20 pt-8 text-[10px] text-gray-400 uppercase tracking-widest flex justify-between">
          <span>© 2024 SOLAER Inc.</span>
          <div className="flex space-x-6">
            <span>Privacy Policy</span>
            <span>Terms of Service</span>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default App;

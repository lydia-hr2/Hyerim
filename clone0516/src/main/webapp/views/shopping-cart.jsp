<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
    // 1. 카트에서 X버튼을 클릭하면 카트에서 해당 품목을 삭제한다.
    let cntChange = {
        init : function () {
            $('.fa-angle-left').on('click', () => {
                $.ajax({
                    method : 'get',
                    url : '/cart/decrease',
                    success : function () {

                    }
                })
            })
            $('.fa-angle-right').on('click', (data) => {
                $.ajax({
                    method : 'get',
                    url : '/cart/increase',
                    success : function () {

                    }
                })
            })
        }
    }
    let deleteItem = {
        init : function () {
            $('#delete_btn').on('click', (e) => {
                let cartId = $(e.currentTarget).data('item-id');
                e.preventDefault();
                $.ajax({
                    method: 'post',
                    url: '/cart/delete',
                    data: {id: cartId}
                }).done(() => {
                    $('#cart' + cartId).remove();
                    $.ajax({
                        method : 'get',
                        url : '/cart/info',
                        data : {id : ${loginmember.id}}
                    }).done((result)=>{
                        $('#totalCnt').text(result.cnt);
                        $('#totalSub').text(addComma(result.price));
                        $('#totalSum').text(addComma(result.price));
                    })
                });
            })
        },
    }

    function addComma(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + '원';
    }
    $(function () {
        deleteItem.init();
        cntChange.init();
    })

    // 2. QUANTITY 를 조정하면 onchange 하고 있다가 desc/increase api post 호출하고 post 에서 받아서 해당 데이터를 조정해준다.
</script>
    <!-- Breadcrumb Section Begin -->
    <section class="breadcrumb-option">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="breadcrumb__text">
                        <h4>Shopping Cart</h4>
                        <div class="breadcrumb__links">
                            <a href="/">Home</a>
                            <a href="/shop">Shop</a>
                            <span>Shopping Cart</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Breadcrumb Section End -->

    <!-- Shopping Cart Section Begin -->
    <section class="shopping-cart spad">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <div class="shopping__cart__table">

                        <c:set var="total" value="0"/>
                        <c:set var="qnt" value="0"/>
                        <table>
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Quantity</th>
                                    <th>Total</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                    <c:forEach var="cart" items="${myCart}">
                                    <tr id="cart${cart.id}">
                                        <td class="product__cart__item">
                                            <div class="product__cart__item__pic">
                                                <img src="/uimg/${cart.img}" alt="" style="width: 90px; height: 90px">
                                            </div>
                                            <div class="product__cart__item__text">
                                                <h6>${cart.name}</h6>
                                                <h5><fmt:formatNumber value="${cart.price}" pattern="#,###,###원" /></h5>
                                            </div>
                                        </td>
                                        <td class="quantity__item">
                                            <div class="quantity">
                                                <div class="pro-qty-2">
                                                    <input type="text" value="${cart.cnt}" id="inputCnt" />
                                                </div>
                                            </div>
                                        </td>
                                        <td class="cart__price"><fmt:formatNumber value="${cart.price * cart.cnt}" pattern="#,###,###원" /></td>
                                        <td class="cart__close"><a data-item-id="${cart.id}" role="button" id="delete_btn" class="btn"><i class="fa fa-close"></i></a></td>
                                    <tr>
                                    <c:set var="total" value="${total + (cart.price * cart.cnt)}"/>
                                    <c:set var="qnt" value="${qnt + cart.cnt}"/>
                                    <input type="hidden" id="totalValue" value="${total + (cart.price * cart.cnt)}">
                                    <input type="hidden" id="qntValue" value="${qnt + cart.cnt}">
                                    </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6">
                            <div class="continue__btn">
                                <a href="/shop">Continue Shopping</a>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6">
                            <div class="continue__btn update__btn">
                                <a href="#"><i class="fa fa-spinner"></i> Update cart</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="cart__discount">
                        <h6>Discount codes</h6>
                        <form action="#">
                            <input type="text" placeholder="Coupon code">
                            <button type="submit">Apply</button>
                        </form>
                    </div>
                    <div class="cart__total">
                        <h6>Cart total</h6>
                        <ul>
                            <li>전체 상품 개수 <span id="totalCnt">${qnt}</span></li>
                            <li>Subtotal <span id="totalSub"><fmt:formatNumber value="${total}" pattern="#,###,###원"/></span></li>
                            <li>Total <span id="totalSum"><fmt:formatNumber value="${total}" pattern="#,###,###원"/></span></li>
                        </ul>
                        <a href="/order/${loginmember.id}" class="primary-btn" role="button">Proceed to checkout</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Shopping Cart Section End -->

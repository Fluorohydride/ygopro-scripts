--スウィッチヒーロー
function c30426226.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c30426226.target)
	e1:SetOperation(c30426226.activate)
	c:RegisterEffect(e1)
end
function c30426226.filter(c)
	return not c:IsAbleToChangeControler()
end
function c30426226.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g1=g:Filter(Card.IsControler,nil,tp)
	local g2=g:Filter(Card.IsControler,nil,1-tp)
	if chk==0 then return g1:GetCount()==g2:GetCount()
		and g:FilterCount(c30426226.filter,nil)==0 end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c30426226.filter2(c,e)
	return not c:IsAbleToChangeControler() or c:IsImmuneToEffect(e)
end
function c30426226.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g1=g:Filter(Card.IsControler,nil,tp)
	local g2=g:Filter(Card.IsControler,nil,1-tp)
	if g1:GetCount()~=g2:GetCount() or g:FilterCount(c30426226.filter2,nil,e)>0 then return end
	local a=g1:GetFirst()
	local b=g2:GetFirst()
	while a and b do
		Duel.SwapControl(a,b)
		a=g1:GetNext()
		b=g2:GetNext()
	end
end

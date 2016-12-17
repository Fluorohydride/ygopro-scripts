--破壊竜ガンドラ－ギガ・レイズ
function c58330108.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c58330108.hspcon)
	e1:SetOperation(c58330108.hspop)
	c:RegisterEffect(e1)
	--atk gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c58330108.value)
	c:RegisterEffect(e2)
	--variable effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(58330108,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c58330108.cost)
	e3:SetTarget(c58330108.target)
	e3:SetOperation(c58330108.operation)
	c:RegisterEffect(e3)
end
function c58330108.hspfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c58330108.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c58330108.hspfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
	return g:GetCount()>=2 and ft>=0 and (ft>0 or g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>0)
end
function c58330108.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<0 then return end
	local hc=2
	local g=Duel.GetMatchingGroup(c58330108.hspfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
	local sg=Group.CreateGroup()
	if ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
		sg:Merge(sg1)
		g:RemoveCard(sg1:GetFirst())
		hc=hc-1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg2=g:Select(tp,hc,hc,nil)
	sg:Merge(sg2)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c58330108.value(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED)*300
end
function c58330108.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c58330108.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf5)
end
function c58330108.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local gc=Duel.GetMatchingGroup(c58330108.filter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
		local b3=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,c)
		return (gc==1 and b1) or (gc==2 and b2) or (gc>2 and b3)
	end
	local cat=CATEGORY_DESTROY
	local rec=nil
	local loc=LOCATION_ONFIELD
	if gc>1 then
		cat=CATEGORY_REMOVE
		rec=Card.IsAbleToRemove
		if gc>2 then loc=LOCATION_ONFIELD+LOCATION_GRAVE end
	end
	e:SetCategory(cat)
	local g=Duel.GetMatchingGroup(rec,tp,loc,loc,c)
	Duel.SetOperationInfo(0,cat,g,g:GetCount(),0,0)
end
function c58330108.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gc=Duel.GetMatchingGroup(c58330108.filter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if gc==1 then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		Duel.Destroy(g,REASON_EFFECT)
	else
		local loc=LOCATION_ONFIELD
		if gc>2 then loc=LOCATION_ONFIELD+LOCATION_GRAVE end
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,loc,loc,c)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

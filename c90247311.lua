--黄竜の忍者
---@param c Card
function c90247311.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c90247311.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90247311,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c90247311.cost)
	e2:SetTarget(c90247311.target)
	e2:SetOperation(c90247311.operation)
	c:RegisterEffect(e2)
end
function c90247311.splimit(e,se,sp,st)
	return (se:IsActiveType(TYPE_MONSTER) and se:GetHandler():IsSetCard(0x2b)) or se:GetHandler():IsSetCard(0x61)
end
function c90247311.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c90247311.cfilter(c)
	return ((c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2b)) or c:IsSetCard(0x61))
		and (c:IsFaceup() or not c:IsOnField())
		and c:IsAbleToGraveAsCost()
end
function c90247311.filter(c,e)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (not e or c:IsCanBeEffectTarget(e))
end
function c90247311.costfilter(c,rg,dg)
	if not (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2b)) then return false end
	local a=0
	if dg:IsContains(c) then a=1 end
	if c:GetEquipCount()==0 then return rg:IsExists(c90247311.costfilter2,1,c,a,dg) end
	local eg=c:GetEquipGroup()
	local tc=eg:GetFirst()
	while tc do
		if dg:IsContains(tc) then a=a+1 end
		tc=eg:GetNext()
	end
	return rg:IsExists(c90247311.costfilter2,1,c,a,dg)
end
function c90247311.costfilter2(c,a,dg)
	if dg:IsContains(c) then a=a+1 end
	return c:IsSetCard(0x61) and #dg-a>=1
end
function c90247311.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c90247311.filter(chkc) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			local rg=Duel.GetMatchingGroup(c90247311.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
			local dg=Duel.GetMatchingGroup(c90247311.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
			return rg:IsExists(c90247311.costfilter,1,nil,rg,dg)
		else
			return Duel.IsExistingTarget(c90247311.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local rg=Duel.GetMatchingGroup(c90247311.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
		local dg=Duel.GetMatchingGroup(c90247311.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=rg:FilterSelect(tp,c90247311.costfilter,1,1,nil,rg,dg)
		local sc=sg1:GetFirst()
		local a=0
		if dg:IsContains(sc) then a=1 end
		if sc:GetEquipCount()>0 then
			local eqg=sc:GetEquipGroup()
			local tc=eqg:GetFirst()
			while tc do
				if dg:IsContains(tc) then a=a+1 end
				tc=eqg:GetNext()
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg2=rg:FilterSelect(tp,c90247311.costfilter2,1,1,sc,a,dg)
		sg1:Merge(sg2)
		Duel.SendtoGrave(sg1,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c90247311.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c90247311.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end

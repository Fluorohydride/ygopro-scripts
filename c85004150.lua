--電子光虫－ライノセバス
function c85004150.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c85004150.mfilter,7,2,nil,nil,5,nil)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(85004150,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c85004150.xyzcon)
	e1:SetOperation(c85004150.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c85004150.atkcost)
	e2:SetTarget(c85004150.atktg)
	e2:SetOperation(c85004150.atkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
end
function c85004150.mfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c85004150.mfilter2(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (c:GetRank()==6 or c:GetRank()==5) and c:IsRace(RACE_INSECT) and c:IsCanBeXyzMaterial(xyzc)
	and c:CheckRemoveOverlayCard(tp,2,REASON_COST)
end
function c85004150.xyzcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c85004150.mfilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c85004150.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c85004150.mfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	g:GetFirst():RemoveOverlayCard(tp,2,2,REASON_EFFECT)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c85004150.atkfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c85004150.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c85004150.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85004150.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c85004150.atkfilter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetDefence)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c85004150.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c85004150.atkfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetDefence)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		else Duel.Destroy(tg,REASON_EFFECT) end
	end
end

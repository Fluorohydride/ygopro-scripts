--電子光虫－ライノセバス
function c85004150.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c85004150.xyzcon)
	e1:SetTarget(c85004150.xyztg)
	e1:SetOperation(c85004150.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c85004150.descost)
	e2:SetTarget(c85004150.destg)
	e2:SetOperation(c85004150.desop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
end
function c85004150.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (c:GetRank()==5 or c:GetRank()==6) and c:IsRace(RACE_INSECT) and c:IsCanBeXyzMaterial(xyzc)
		and c:CheckRemoveOverlayCard(tp,2,REASON_COST)
end
function c85004150.mfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c85004150.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	if ct<1 and (not min or min<=1) and mg:IsExists(c85004150.ovfilter,1,nil,tp,c) then
		return true
	end
	local minc=2
	local maxc=5
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	return ct<minc and Duel.CheckXyzMaterial(c,c85004150.mfilter,7,minc,maxc,og)
end
function c85004150.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then
		return true
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	local minc=2
	local maxc=5
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	local b1=ct<minc and Duel.CheckXyzMaterial(c,c85004150.mfilter,7,minc,maxc,og)
	local b2=ct<1 and (not min or min<=1) and mg:IsExists(c85004150.ovfilter,1,nil,tp,c)
	local g=nil
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(85004150,0))) then
		e:SetLabel(1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c85004150.ovfilter,1,1,nil,tp,c)
		g:GetFirst():RemoveOverlayCard(tp,2,2,REASON_COST)
	else
		e:SetLabel(0)
		g=Duel.SelectXyzMaterial(tp,c,c85004150.mfilter,7,minc,maxc,og)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c85004150.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg=e:GetLabelObject()
		if e:GetLabel()==1 then
			local mg2=mg:GetFirst():GetOverlayGroup()
			if mg2:GetCount()~=0 then
				Duel.Overlay(c,mg2)
			end
		end
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
end
function c85004150.desfilter(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function c85004150.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c85004150.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85004150.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c85004150.desfilter,tp,0,LOCATION_MZONE,nil)
	local dg=g:GetMaxGroup(Card.GetDefense)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c85004150.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c85004150.desfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local dg=g:GetMaxGroup(Card.GetDefense)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end

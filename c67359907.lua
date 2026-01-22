--超征竜－ディザスター
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.mtcon)
	e1:SetTarget(s.mttg)
	e1:SetOperation(s.mtop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	e2:SetCondition(s.effcon)
	c:RegisterEffect(e2)
	--atk and def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.effcon)
	e3:SetValue(4600)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsRank(7)
end
function s.matfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x1c4) and c:IsLevel(7) and c:IsCanOverlay()
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,s.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,4,nil)
	local gg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if gg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,gg,gg:GetCount(),0,0)
	end
end
function s.mtfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsCanOverlay()
end
function s.rmfilter(c,xg)
	return c:IsType(TYPE_MONSTER) and xg:IsExists(Card.IsAttribute,1,nil,c:GetAttribute()) and c:IsAbleToRemove() and c:IsFaceupEx()
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.mtfilter,nil,e)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.Overlay(c,g)
		Duel.AdjustAll()
		local xg=c:GetOverlayGroup()
		if Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,nil,xg) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			local rg=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,nil,xg)
			if rg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function s.attfilter(c)
	return c:IsSetCard(0x1c4) and c:IsType(TYPE_MONSTER)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	local att=0
	for tc in aux.Next(g) do
		if s.attfilter(tc) then
			att=att|tc:GetAttribute()
		end
	end
	local gattr=ATTRIBUTE_EARTH|ATTRIBUTE_WATER|ATTRIBUTE_FIRE|ATTRIBUTE_WIND|ATTRIBUTE_LIGHT|ATTRIBUTE_DARK
	return att&gattr==gattr
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

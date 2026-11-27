--CX 冀望皇龍カオス・バリアン・ドラゴン
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,3,s.ovfilter,aux.Stringid(id,0),99)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--disable search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(s.nscon)
	e2:SetTargetRange(0,1)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	c:RegisterEffect(e2)
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.mtcost)
	e3:SetTarget(s.mttg)
	e3:SetOperation(s.mtop)
	c:RegisterEffect(e3)
end
function s.ovfilter(c)
	local no=aux.GetXyzNumber(c)
	return c:IsFaceup() and no and no>=101 and no<=107 and c:IsSetCard(0x1048)
end
function s.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function s.cfilter(c)
	return c:IsSetCard(0x1048) and c:IsType(TYPE_MONSTER)
end
function s.nscon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(s.cfilter,1,nil)
end
function s.mtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>1 end
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,2)
	if c:IsRelateToChain() and g:GetCount()>0 then
		local og=Group.CreateGroup()
		local sg=Group.CreateGroup()
		for tc in aux.Next(g) do
			if tc:IsCanOverlay() then
				og:AddCard(tc)
			else
				sg:AddCard(tc)
			end
		end
		if og:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.Overlay(c,og)
		end
		if sg:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(sg,REASON_RULE)
		end
	end
end

--デビルマゼラ
---@param c Card
function c6133894.initial_effect(c)
	aux.AddCodeList(c,66073051,94585852)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c6133894.spcon)
	e2:SetTarget(c6133894.sptg)
	e2:SetOperation(c6133894.spop)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6133894,0))
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c6133894.hdtg)
	e3:SetOperation(c6133894.hdop)
	c:RegisterEffect(e3)
end
function c6133894.rfilter(c,tp)
	return c:IsFaceup() and c:IsCode(66073051) and Duel.GetMZoneCount(tp,c)>0
end
function c6133894.spcon(e,c)
	if c==nil then return Duel.IsEnvironment(94585852) end
	return Duel.CheckReleaseGroupEx(c:GetControler(),c6133894.rfilter,1,REASON_SPSUMMON,false,nil,c:GetControler())
end
function c6133894.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c6133894.rfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c6133894.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function c6133894.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,3)
end
function c6133894.hdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsEnvironment(94585852,tp) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,3)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end

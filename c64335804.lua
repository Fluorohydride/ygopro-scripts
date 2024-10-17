--レッドアイズ・ブラックメタルドラゴン
---@param c Card
function c64335804.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(c64335804.spcon)
	e1:SetTarget(c64335804.sptg)
	e1:SetOperation(c64335804.spop)
	c:RegisterEffect(e1)
end
function c64335804.spfilter(c,tp)
	return c:IsCode(74677422) and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,68540058)
		and Duel.GetMZoneCount(tp,c)>0
end
function c64335804.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c64335804.spfilter,1,REASON_SPSUMMON,false,nil,tp)
end
function c64335804.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c64335804.spfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c64335804.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	Duel.ShuffleDeck(tp)
end

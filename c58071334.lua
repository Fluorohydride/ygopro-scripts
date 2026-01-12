--蛇眼の原罪龍
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,s.mfilter1,s.mfilter2,true)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.hspcon)
	e1:SetTarget(s.hsptg)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.mvtg)
	e2:SetOperation(s.mvop)
	c:RegisterEffect(e2)
end
function s.mfilter1(c)
	return c:IsFusionSetCard(0x19c)
end
function s.mfilter2(c)
	return c:IsRace(RACE_ILLUSION)
end
function s.sprfilter(c,sc)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsFaceup()
		and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function s.sgchk(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_SZONE,0,c,c)
	return g:CheckSubGroup(s.sgchk,2,2,tp,c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local cp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.sprfilter,cp,LOCATION_SZONE,0,c,c)
	Duel.Hint(HINT_SELECTMSG,cp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(cp,s.sgchk,true,2,2,cp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_SPSUMMON)
end
function s.mvfilter(c,tp)
	local r=LOCATION_REASON_TOFIELD
	if not c:IsControler(c:GetOwner()) then
		if not c:IsAbleToChangeControler() then return false end
		r=LOCATION_REASON_CONTROL
	end
	return c:IsFaceup() and Duel.GetLocationCount(c:GetOwner(),LOCATION_SZONE,tp,r)>0
end
function s.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.mvfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.mvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.mvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and not tc:IsImmuneToEffect(e)
		and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end

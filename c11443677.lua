--ブルーアイズ・タイラント・ドラゴン
---@param c Card
function c11443677.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,89631139,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),1,true,true)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c11443677.sprcon)
	e2:SetTarget(c11443677.sprtg)
	e2:SetOperation(c11443677.sprop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c11443677.efilter)
	c:RegisterEffect(e3)
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--set trap
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11443677,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(c11443677.setcon)
	e5:SetTarget(c11443677.settg)
	e5:SetOperation(c11443677.setop)
	c:RegisterEffect(e5)
end
function c11443677.ultimate_fusion_check(tp,sg,fc)
	return aux.gffcheck(sg,Card.IsFusionCode,89631139,Card.IsRace,RACE_DRAGON)
end
function c11443677.cfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_FUSION~=0
end
function c11443677.sprfilter(c,tp,sc)
	local eqc=c:GetEquipGroup():FilterCount(c11443677.cfilter,nil)
	return c:IsFusionCode(89631139) and eqc>0 and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c11443677.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c11443677.sprfilter,1,REASON_SPSUMMON,false,nil,tp,c)
end
function c11443677.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c11443677.sprfilter,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c11443677.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	c:SetMaterial(Group.FromCards(tc))
	Duel.Release(tc,REASON_SPSUMMON)
end
function c11443677.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c11443677.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(11443677)==0 and aux.dsercon(e,tp,eg,ep,ev,re,r,rp)
end
function c11443677.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c11443677.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11443677.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11443677.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c11443677.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	if e:IsCostChecked() then
		e:GetHandler():RegisterFlagEffect(11443677,RESET_EVENT|RESET_TOFIELD|RESET_TURN_SET|RESET_PHASE|PHASE_END,0,0,1)
	end
end
function c11443677.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
	end
end

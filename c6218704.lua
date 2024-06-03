--覇王天龍オッドアイズ・アークレイ・ドラゴン
function c6218704.initial_effect(c)
	aux.AddCodeList(c,13331639)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,c6218704.fusfilter1,c6218704.fusfilter2,c6218704.fusfilter3,c6218704.fusfilter4)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c6218704.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c6218704.hspcon)
	e2:SetTarget(c6218704.hsptg)
	e2:SetOperation(c6218704.hspop)
	c:RegisterEffect(e2)
	--pzone effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6218704,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,6218704)
	e3:SetCondition(c6218704.pcon)
	e3:SetTarget(c6218704.ptg)
	e3:SetOperation(c6218704.pop)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(6218704,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c6218704.setcon)
	e4:SetTarget(c6218704.settg)
	e4:SetOperation(c6218704.setop)
	c:RegisterEffect(e4)
	--pendulum
	aux.AddPlaceToPZoneIfDestroyEffect(c)
end
c6218704.material_type=TYPE_SYNCHRO
function c6218704.fusfilter1(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_FUSION)
end
function c6218704.fusfilter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_SYNCHRO)
end
function c6218704.fusfilter3(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_XYZ)
end
function c6218704.fusfilter4(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_PENDULUM)
end
function c6218704.splimit(e,se,sp,st)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() then return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION end
	return true
end
function c6218704.hspfilter(c,tp,sc)
	return c:IsCode(13331639) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(12) and c:IsFaceup()
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c6218704.hspcon(e,c)
	if c==nil then return true end
	return c:IsFacedown() and Duel.CheckReleaseGroupEx(c:GetControler(),c6218704.hspfilter,1,REASON_SPSUMMON,false,nil,c:GetControler(),c)
end
function c6218704.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c6218704.hspfilter,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c6218704.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	c:SetMaterial(Group.FromCards(tc))
	Duel.Release(tc,REASON_SPSUMMON)
end
function c6218704.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>=2
end
function c6218704.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c6218704.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_PZONE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(6218704,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			if sc and Duel.SendtoDeck(sc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and sc:IsLocation(LOCATION_EXTRA) and sc:IsControler(tp)
				and sc:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,sc)>0
				and Duel.SelectYesNo(tp,aux.Stringid(6218704,2)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end
function c6218704.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function c6218704.setfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c6218704.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c6218704.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c6218704.setop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c6218704.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
		tc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end

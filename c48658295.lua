--ドラゴンメイド・ラティス
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddFusionProcFunRep(c,s.ffilter,2,false)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.sptg1)
	e3:SetOperation(s.spop1)
	c:RegisterEffect(e3)
	--fusion summon
	local e4=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_MZONE|LOCATION_REMOVED,
		mat_operation_code_map={
			{ [LOCATION_DECK]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_SHUFFLE }
		},
		extra_target=s.extra_target
	})
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1,id+o)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
end

function s.ffilter(c,fc,sub,mg,sg)
	if not c:IsFusionSetCard(0x133) then return false end
	if not sg then return true end
	return not sg:IsExists(Card.IsLevel,1,c,c:GetLevel())
		and sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute())
end

function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function s.selffusfilter(c)
	return c:IsSetCard(0x133) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

function s.fselect(g)
	return g:GetClassCount(Card.GetLevel)==2 and aux.SameValueCheck(g,Card.GetFusionAttribute) and g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local fg=Duel.GetMatchingGroup(s.selffusfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return fg:CheckSubGroup(s.fselect,2,2)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local cp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.selffusfilter,cp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,cp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(cp,s.fselect,true,2,2)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	c:SetMaterial(sg)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x133) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4)
end

function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.fusfilter(c)
	return c:IsRace(RACE_DRAGON)
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE+LOCATION_REMOVED)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end

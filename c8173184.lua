--リペア・ジェネクス・コントローラー
--not fully implemented
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,s.mfilter,1,1)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.smcon)
	e2:SetTarget(s.smtg)
	e2:SetOperation(s.smop)
	c:RegisterEffect(e2)
end
function s.mfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x2)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.thfilter(c)
	return c:IsSetCard(0x2) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.smfilter(c)
	return c:IsSetCard(0x2) and c:IsSummonable(true,nil)
end
function s.trigfilter(c,tp)
	return c:IsSetCard(0x2) and c:IsControler(tp) and c:IsType(TYPE_MONSTER) and not c:IsReason(REASON_DRAW)
		and not (c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and not c:IsPublic())
		and (not c:IsStatus(STATUS_TO_HAND_WITHOUT_CONFIRM) or (c:IsStatus(STATUS_TO_HAND_WITHOUT_CONFIRM) and c:IsPublic()))
end
function s.smcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.trigfilter,1,nil,tp)
end
function s.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.smfilter,tp,LOCATION_HAND,0,1,nil)
		and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.smop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.smfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetTarget(s.splimit)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	--splimit2
	local e1=e0:Clone()
	e1:SetTarget(s.splimit1)
	Duel.RegisterEffect(e1,tp)
	--synchro level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTarget(s.syntg)
	e3:SetValue(1)
	e3:SetOperation(s.synop)
	local e31=Effect.CreateEffect(c)
	e31:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e31:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e31:SetReset(RESET_PHASE+PHASE_END)
	e31:SetTargetRange(LOCATION_MZONE,0)
	e31:SetLabelObject(e3)
	Duel.RegisterEffect(e31,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and bit.band(sumtype,SUMMON_TYPE_SYNCHRO)~=SUMMON_TYPE_SYNCHRO
end
function s.splimit1(e,c,sump,sumtype,sumpos,targetp,se)
	return se:IsHasType(EFFECT_TYPE_ACTIONS) and c:IsLocation(LOCATION_EXTRA)
end
function s.smcfilter(c,sc)
	return c:IsSetCard(0x2) and c:IsType(TYPE_TUNER)
end
function s.synfilter(c,syncard,tuner,f)
	return c:IsFaceupEx() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function s.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=s.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(s.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function s.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL)
		and g:IsExists(s.smcfilter,1,nil,syncard)
end
function s.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(s.synfilter,c,syncard,c,f)
	return mg:IsExists(s.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function s.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(s.synfilter,c,syncard,c,f)
	for i=1,maxc do
		local cg=mg:Filter(s.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if s.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	Duel.SetSynchroMaterial(g)
end

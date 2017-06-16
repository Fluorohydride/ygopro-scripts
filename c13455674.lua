--水晶機巧－グリオンガンド
function c13455674.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c13455674.syncon)
	e1:SetOperation(c13455674.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13455674,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c13455674.rmcon)
	e2:SetTarget(c13455674.rmtg)
	e2:SetOperation(c13455674.rmop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13455674,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c13455674.spcon)
	e3:SetTarget(c13455674.sptg)
	e3:SetOperation(c13455674.spop)
	c:RegisterEffect(e3)
	--double tuner
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(21142671)
	c:RegisterEffect(e4)
end
function c13455674.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c13455674.matfilter2(c,syncard)
	return c:IsNotTuner() and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c13455674.synfilter(c,syncard,lv,g1,pg,ct)
	local g=Group.FromCards(c)
	g:Merge(pg)
	Duel.SetSelectedCard(g)
	return g1:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,63,syncard)
end
function c13455674.syncon(e,c,tuner,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-2 then return false end
	local g1=nil
	local g2=nil
	if mg then
		g1=mg:Filter(c13455674.matfilter1,nil,c)
		g2=mg:Filter(c13455674.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c13455674.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c13455674.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local pg=Group.CreateGroup()
	local ct=2
	if tuner then
		pg:AddCard(tuner)
		ct=ct-1
	end
	if pe then
		pg:AddCard(pe:GetOwner())
		ct=ct-1
	end
	return g2:IsExists(c13455674.synfilter,1,nil,c,lv,g1,pg,ct)
end
function c13455674.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	if mg then
		g1=mg:Filter(c13455674.matfilter1,nil,c)
		g2=mg:Filter(c13455674.matfilter2,nil,c)
	else
		g1=Duel.GetMatchingGroup(c13455674.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g2=Duel.GetMatchingGroup(c13455674.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local ct=2
	if tuner then
		g:AddCard(tuner)
		ct=ct-1
	end
	if pe then
		local pc=pe:GetOwner()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		Group.FromCards(pc):Select(tp,1,1,nil)
		g:AddCard(pc)
		ct=ct-1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local m2=g2:FilterSelect(tp,c13455674.synfilter,1,1,nil,c,lv,g1,g,ct)
	g:Merge(m2)
	Duel.SetSelectedCard(g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local m1=g1:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,ct,63,c)
	g:Merge(m1)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function c13455674.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c13455674.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c13455674.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetMaterialCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(1-tp) and c13455674.rmfilter(chkc) end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(c13455674.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c13455674.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c13455674.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c13455674.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c13455674.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13455674.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c13455674.spfilter(chkc,e,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c13455674.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c13455674.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c13455674.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
